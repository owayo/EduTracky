import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:client/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('アプリの基本機能テスト', (WidgetTester tester) async {
    // アプリケーションをビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // アプリケーションが正常に起動することを確認
    expect(find.byType(MaterialApp), findsOneWidget);

    // 初期画面が表示されることを確認
    expect(find.text('EduTracky'), findsOneWidget);
  });

  testWidgets('テーマ設定が正しく適用されていることをテスト', (WidgetTester tester) async {
    // アプリケーションをビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // MaterialAppのthemeが設定されていることを確認
    final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
  });
}
