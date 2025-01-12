import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('成績分析'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '成績推移'),
              Tab(text: '分野別分析'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ScoreHistoryTab(),
            _SubjectAnalysisTab(),
          ],
        ),
      ),
    );
  }
}

class _ScoreHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // サンプルデータ
    final scores = [
      FlSpot(0, 75),
      FlSpot(1, 80),
      FlSpot(2, 85),
      FlSpot(3, 82),
      FlSpot(4, 88),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '点数の推移',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: scores,
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectAnalysisTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SubjectCard(
          subject: '数学',
          score: 85,
          strengths: ['方程式', '図形'],
          weaknesses: ['確率', '関数'],
        ),
        const SizedBox(height: 16),
        _SubjectCard(
          subject: '国語',
          score: 78,
          strengths: ['読解', '漢字'],
          weaknesses: ['作文', '古文'],
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.score,
    required this.strengths,
    required this.weaknesses,
  });

  final String subject;
  final int score;
  final List<String> strengths;
  final List<String> weaknesses;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$score点',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '得意分野',
              style: TextStyle(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              children: strengths
                  .map((strength) => Chip(label: Text(strength)))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              '苦手分野',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              children: weaknesses
                  .map((weakness) => Chip(label: Text(weakness)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}