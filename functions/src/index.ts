import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { ImageAnnotatorClient } from '@google-cloud/vision';
import { PredictionServiceClient } from '@google-cloud/aiplatform';
import { LocationServiceClient } from '@google-cloud/aiplatform';

admin.initializeApp();

const vision = new ImageAnnotatorClient();
const predictionClient = new PredictionServiceClient();
const locationClient = new LocationServiceClient();

// テスト画像が保存されたときに実行される関数
export const analyzeTest = functions.storage.object().onFinalize(async (object) => {
  if (!object.name) return;
  
  // 画像ファイルでない場合は処理をスキップ
  if (!object.contentType?.includes('image/')) {
    functions.logger.log('Not an image file');
    return;
  }

  const bucket = admin.storage().bucket(object.bucket);
  const filePath = object.name;
  
  try {
    // Vision AIによる画像解析
    const [result] = await vision.textDetection(`gs://${object.bucket}/${filePath}`);
    const detections = result.textAnnotations;
    
    if (!detections || detections.length === 0) {
      throw new Error('No text found in image');
    }

    // テキスト解析結果から成績データを抽出
    const extractedData = extractTestData(detections[0].description || '');
    
    // Firestoreに解析結果を保存
    const testDoc = {
      imageUrl: `gs://${object.bucket}/${filePath}`,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      rawText: detections[0].description,
      ...extractedData,
    };

    await admin.firestore().collection('tests').add(testDoc);

    // Vertex AIによる分析の実行
    await analyzeWithVertexAI(extractedData);

  } catch (error) {
    functions.logger.error('Error processing image:', error);
    throw error;
  }
});

// テキストから成績データを抽出する関数
function extractTestData(text: string) {
  // ここで正規表現などを使って必要なデータを抽出
  // 仮実装として簡単な例を示す
  const lines = text.split('\n');
  const data = {
    studentName: '',
    score: 0,
    questions: [] as Array<{number: number, score: number}>,
  };

  for (const line of lines) {
    // 名前の抽出（「名前：」または「氏名：」の後ろの文字列）
    const nameMatch = line.match(/[名氏]前[：:]\s*(.+)/);
    if (nameMatch) {
      data.studentName = nameMatch[1];
    }

    // 合計点数の抽出（「点数：」または「得点：」の後ろの数字）
    const scoreMatch = line.match(/[点得]数[：:]\s*(\d+)/);
    if (scoreMatch) {
      data.score = parseInt(scoreMatch[1]);
    }

    // 各問題の点数抽出（「問題X：Y点」のような形式）
    const questionMatch = line.match(/問題(\d+)[：:]\s*(\d+)点/);
    if (questionMatch) {
      data.questions.push({
        number: parseInt(questionMatch[1]),
        score: parseInt(questionMatch[2]),
      });
    }
  }

  return data;
}

// Vertex AIによる分析を行う関数
async function analyzeWithVertexAI(data: any) {
  const projectId = process.env.GCP_PROJECT_ID;
  const location = 'us-central1';
  const modelId = 'YOUR_MODEL_ID'; // Vertex AIのモデルID

  const endpoint = `projects/${projectId}/locations/${location}/endpoints/${modelId}`;

  try {
    const request = {
      endpoint,
      instances: [
        {
          score: data.score,
          questions: data.questions,
        },
      ],
    };

    const [response] = await predictionClient.predict(request);

    // 分析結果をFirestoreに保存
    await admin.firestore().collection('analysis').add({
      studentId: data.studentName,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      predictions: response.predictions,
    });

  } catch (error) {
    functions.logger.error('Error in Vertex AI analysis:', error);
    throw error;
  }
}
