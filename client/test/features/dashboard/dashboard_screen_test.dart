import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/dashboard/screens/dashboard_screen.dart';

void main() {
  testWidgets('ダッシュボード画面の基本UIをテスト', (WidgetTester tester) async {
    // ダッシュボード画面をビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // AppBarのタイトルが表示されていることを確認
    expect(find.text('ダッシュボード'), findsOneWidget);

    // FloatingActionButtonが表示されていることを確認（テスト用紙撮影ボタン）
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('ダッシュボードの各セクションが表示されることをテスト', (WidgetTester tester) async {
    // ダッシュボード画面をビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // 学力推移グラフのセクションが表示されることを確認
    expect(find.text('学力推移'), findsOneWidget);

    // 最近のテスト結果セクションが表示されることを確認
    expect(find.text('最近のテスト結果'), findsOneWidget);
  });
}
