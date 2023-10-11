import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: const AnimatedStackedBarChart(),
      ),
    ));
  }
}


class AnimatedStackedBarChart extends StatefulWidget {
  const AnimatedStackedBarChart({super.key});

  @override
  _AnimatedStackedBarChartState createState() => _AnimatedStackedBarChartState();
}

class _AnimatedStackedBarChartState extends State<AnimatedStackedBarChart> {
  List<List<ChartData>> dataSets = [
    [
      ChartData('Jan', 30, 20, 10),
      ChartData('Feb', 40, 30, 20),
      ChartData('Mar', 10, 40, 30),
    ],
    [
      ChartData('Feb', 40, 30, 20),
      ChartData('Jan', 30, 20, 10),
      ChartData('Mar', 10, 40, 30),
    ],
    [
      ChartData('Mar', 10, 40, 30),
      ChartData('Feb', 40, 30, 20),
      ChartData('Jan', 30, 20, 10),
    ],
  ];

  int currentDataSetIndex = 0;

  void switchDataSets() {
    setState(() {
      currentDataSetIndex = (currentDataSetIndex + 1) % dataSets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (BuildContext context, double value, Widget? child) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <StackedBarSeries<ChartData, String>>[
              StackedBarSeries<ChartData, String>(
                dataSource: dataSets[currentDataSetIndex],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value1,
              ),
              StackedBarSeries<ChartData, String>(
                dataSource: dataSets[currentDataSetIndex],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value2,
              ),
              StackedBarSeries<ChartData, String>(
                dataSource: dataSets[currentDataSetIndex],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value3,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: switchDataSets,
          child: const Text('Switch Data Sets'),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value1;
  final double value2;
  final double value3;

  ChartData(this.category, this.value1, this.value2, this.value3);
}