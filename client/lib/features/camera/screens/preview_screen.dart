import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class PreviewScreen extends StatelessWidget {
  final XFile imageFile;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;

  const PreviewScreen({
    super.key,
    required this.imageFile,
    required this.onRetake,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プレビュー'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                imageFile.path,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: onRetake,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('撮り直す'),
                ),
                FilledButton.icon(
                  onPressed: onConfirm,
                  icon: const Icon(Icons.check),
                  label: const Text('この画像を使用'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}