import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/camera/screens/camera_screen.dart';

void main() {
  testWidgets('カメラ画面の基本UIをテスト', (WidgetTester tester) async {
    // カメラ画面をビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CameraScreen(),
        ),
      ),
    );

    // AppBarのタイトルが表示されていることを確認
    expect(find.text('テスト用紙を撮影'), findsOneWidget);

    // 初期状態では読み込み中のインジケータが表示されることを確認
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
