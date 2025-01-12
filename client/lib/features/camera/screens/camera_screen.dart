import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'dart:js' as js;

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // カメラを要求する前に、navigator.mediaDevices が利用可能か確認
      final hasMediaDevices = js.context.hasProperty('navigator') &&
          js.context['navigator'].hasProperty('mediaDevices');

      if (!hasMediaDevices) {
        setState(() {
          _errorMessage = 'このブラウザではカメラを使用できません';
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'カメラが見つかりません';
        });
        return;
      }

      final camera = cameras.first;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
            _errorMessage = null;
          });
        }
      } on CameraException catch (e) {
        String message = 'カメラの初期化に失敗しました';
        if (e.description.contains('Permission denied')) {
          message = 'カメラへのアクセスが許可されていません。\nブラウザの設定でカメラへのアクセスを許可してください。';
        }
        setState(() {
          _errorMessage = message;
        });
        debugPrint('カメラの初期化エラー: $e');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'カメラの初期化に失敗しました: $e';
      });
      debugPrint('カメラのアクセスエラー: $e');
    }
  }

  Future<void> _openBrowserSettings() async {
    // URLバー左のカメラアイコンをクリックするよう促すメッセージを表示
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('カメラの設定'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('以下の手順でカメラへのアクセスを許可してください：'),
            SizedBox(height: 8),
            Text('1. URLバーの左にあるカメラアイコンをクリック'),
            Text('2. [カメラ] を [許可] に設定'),
            Text('3. ページを再読み込み'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isLoading = true);

    try {
      final image = await _controller!.takePicture();
      if (mounted) {
        context.go('/dashboard/camera/preview', extra: image);
      }
    } catch (e) {
      debugPrint('写真の撮影に失敗: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('写真の撮影に失敗しました'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('テスト用紙を撮影'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.no_photography,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _openBrowserSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('カメラの設定を開く'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('テスト用紙を撮影'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.icon(
                  onPressed: _isLoading ? null : _takePicture,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.camera_alt),
                  label: const Text('撮影'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}