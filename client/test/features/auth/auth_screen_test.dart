import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/screens/auth_screen.dart';

void main() {
  testWidgets('認証画面の基本要素が表示されることをテスト', (WidgetTester tester) async {
    // 認証画面をビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );

    // タイトルが表示されていることを確認
    expect(find.text('EduTracky'), findsOneWidget);

    // ログインボタンが表示されていることを確認
    expect(find.widgetWithText(FilledButton, 'ログイン'), findsOneWidget);

    // Googleログインボタンが表示されていることを確認
    expect(find.byIcon(Icons.login), findsOneWidget);
  });
}
