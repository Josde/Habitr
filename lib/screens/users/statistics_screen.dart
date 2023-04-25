import 'package:flutter/material.dart';
import 'package:habitr_tfg/widgets/rounded_container.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stadistics')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedContainer(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildMaxStreakWidget())),
                  Spacer(),
                  RoundedContainer(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildCurrentStreakWidget())),
                  Spacer(),
                  RoundedContainer(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildMonthlyStatsWidget()),
                  ),
                  Spacer(),
                  RoundedContainer(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildYearlyStatsWidget()),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

Widget buildMaxStreakWidget() {
  return Container(
    constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Max streak'),
            Text('7'),
          ],
        ),
        Spacer(),
        Text('7/10/22 - 14/10/22')
      ],
    ),
  );
}

Widget buildCurrentStreakWidget() {
  //FIXME: This widget currently overflows
  return Container(
    constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Streak'),
            Text('7'),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {},
                ),
                Text('Current Week'),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {},
                )
              ],
            ),
            Text('7/10/22 - 14/10/22'),
          ],
        )
      ],
    ),
  );
}

Widget buildMonthlyStatsWidget() {
  return Container(
    constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
    child: BarChart(BarChartData(
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(enabled: false),
        borderData: FlBorderData(show: false),
        groupsSpace: 10.0,
        alignment: BarChartAlignment.center,
        maxY: 16.0,
        titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return Text('J');
                  case 2:
                    return Text('F');
                  case 3:
                    return Text('M');
                  case 4:
                    return Text('A');
                  case 5:
                    return Text('M');
                  case 6:
                    return Text('J');
                  case 7:
                    return Text('J');
                  case 8:
                    return Text('A');
                  case 9:
                    return Text('S');
                  case 10:
                    return Text('O');
                  case 11:
                    return Text('N');
                  case 12:
                    return Text('D');
                }
                return Text('');
              },
            ))),
        barGroups: <BarChartGroupData>[
          BarChartGroupData(
              x: 1, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 2, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 3, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 4, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 5, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 6, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 7, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 8, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 9, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 10, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 11, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
          BarChartGroupData(
              x: 12, barRods: <BarChartRodData>[BarChartRodData(toY: 10.0)]),
        ])),
  );
}

Widget buildYearlyStatsWidget() {
  return Container();
}
