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

    // AppBarのタイトルが表示されることを確認
    expect(find.text('EduTracky'), findsOneWidget);

    // メニューセクションのタイトルが表示されることを確認
    expect(find.text('メニュー'), findsOneWidget);

    // メニューカードが表示されることを確認
    expect(find.text('テストを撮影'), findsOneWidget);
    expect(find.text('学力を分析'), findsOneWidget);
    expect(find.text('テスト履歴'), findsOneWidget);
    expect(find.text('お子様管理'), findsOneWidget);

    // 最近のテストセクションが表示されることを確認
    expect(find.text('最近のテスト'), findsOneWidget);
  });

  testWidgets('今月のテスト平均が表示されることをテスト', (WidgetTester tester) async {
    // ダッシュボード画面をビルド
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // 今月のテスト平均のセクションが表示されることを確認
    expect(find.text('今月のテスト平均'), findsOneWidget);
    expect(find.text('83'), findsOneWidget);
    expect(find.text('点'), findsOneWidget);
  });
}
