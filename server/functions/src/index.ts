import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as vision from "@google-cloud/vision";

// Firebaseの初期化
admin.initializeApp();

// Vision AIクライアントの初期化
const visionClient = new vision.ImageAnnotatorClient();

// テスト画像のOCR処理
export const analyzeTest = functions.storage.object().onFinalize(async (object) => {
  if (!object.name) {
    return;
  }

  // 画像のパスを取得
  const filePath = object.name;
  
  try {
    // Vision AIでOCR実行
    const [result] = await visionClient.textDetection(`gs://${object.bucket}/${filePath}`);
    const detections = result.textAnnotations;
    
    if (!detections || detections.length === 0) {
      console.log("テキストが検出されませんでした");
      return;
    }

    // 検出されたテキストを保存
    const text = detections[0].description;
    await admin.firestore().collection("test_results").add({
      filePath,
      text,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log("OCR処理が完了しました");
  } catch (error) {
    console.error("OCR処理中にエラーが発生しました:", error);
  }
});
