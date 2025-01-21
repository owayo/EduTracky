import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アプリロゴ
              const Text(
                'EduTracky',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // ログインボタン
              FilledButton.icon(
                onPressed: () {
                  // TODO: ログイン処理を実装
                },
                icon: const Icon(Icons.login),
                label: const Text('ログイン'),
              ),
              
              const SizedBox(height: 16),
              
              // Googleログインボタン
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Googleログイン処理を実装
                },
                icon: const Icon(Icons.login),
                label: const Text('Googleでログイン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
