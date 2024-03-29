/// {@category GestionEstadisticas}
/// {@category Vista}
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitr_tfg/blocs/routines/completion/bloc/routine_completion_bloc.dart';
import 'package:habitr_tfg/blocs/users/self/self_bloc.dart';
import 'package:habitr_tfg/data/classes/routinecompletion.dart';
import 'package:habitr_tfg/widgets/loading.dart';
import 'package:habitr_tfg/widgets/rounded_container.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/classes/streak.dart';
import '../../data/classes/user.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stadistics'),
        backgroundColor: Theme.of(context).iconTheme.color,
      ),
      body: SafeArea(
        child: Center(
          // FIXME: Add blocbuilders here
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  RoundedContainer(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildMaxStreakWidget(context))),
                  Spacer(),
                  RoundedContainer(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildCurrentStreakWidget(context))),
                  Spacer(),
                  RoundedContainer(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildMonthlyStatsWidget(context)),
                  ),
                  Spacer()
                ]),
          ),
        ),
      ),
    );
  }
}

Widget buildMaxStreakWidget(BuildContext context) {
  var state = BlocProvider.of<SelfBloc>(context).state;
  Widget _child;
  if (state is SelfLoaded || (state is SelfError && state.self != null)) {
    User self = BlocProvider.of<SelfBloc>(context).state.self!;
    Streak maxStreak = self.maxStreak ??
        Streak(startDate: DateTime.now(), endDate: DateTime.now());
    _child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Max streak'),
              Text(
                  '${maxStreak.endDate.difference(maxStreak.startDate).inDays} days'),
            ],
          ),
          Spacer(),
          Text(
              //FIXME: Temp solution. Taken from https://stackoverflow.com/a/62449867
              '${maxStreak.startDate.toString().substring(0, 10)} - ${maxStreak.endDate.toString().substring(0, 10)}')
        ]);
  } else {
    _child = LoadingSpinner();
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
      child: _child,
    ),
  );
}

Widget buildCurrentStreakWidget(BuildContext context) {
  Widget _child;
  var state = BlocProvider.of<SelfBloc>(context).state;
  if (state is SelfLoaded || (state is SelfError && state.self != null)) {
    User self = BlocProvider.of<SelfBloc>(context).state.self!;
    Streak? currentStreak = self.currentStreak ??
        Streak(startDate: DateTime.now(), endDate: DateTime.now());
    _child = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current streak'),
            Text(
                '${DateTime.now().difference(currentStreak.startDate).inDays} days'),
          ],
        ),
        Spacer(),
        Text('${currentStreak.startDate.toString().substring(0, 10)} - ?'),
      ],
    );
  } else {
    _child = LoadingSpinner();
  }
  return Container(
    constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
    child: Padding(padding: const EdgeInsets.all(8.0), child: _child),
  );
}

Widget buildMonthlyStatsWidget(BuildContext context) {
  int max = 0;
  List<BarChartGroupData> chartData = List.empty(growable: true);
  DateTime now = DateTime.now();
  List<RoutineCompletion> rc = List.empty(growable: true);
  RoutineCompletionState state =
      BlocProvider.of<RoutineCompletionBloc>(context).state;
  if (state is RoutineCompletionLoaded) {
    rc = state.routineCompletions;
  }
  List<List<RoutineCompletion>> rcByMonth = List.empty(growable: true);

  for (int _month = 1; _month <= 12; _month++) {
    List<RoutineCompletion> tmp = rc
        .where((completion) =>
            completion.time.month == _month && completion.time.year == now.year)
        .toList();
    if (tmp.length > max) max = tmp.length;
    print(tmp.length);
    rcByMonth.add(tmp);
    chartData.add(BarChartGroupData(
        x: _month, barRods: [BarChartRodData(toY: tmp.length.toDouble())]));
  }
  return Container(
    constraints: BoxConstraints(maxWidth: 250, maxHeight: 100),
    child: BarChart(BarChartData(
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(enabled: false),
        borderData: FlBorderData(show: false),
        groupsSpace: 10.0,
        alignment: BarChartAlignment.center,
        maxY: max.toDouble(),
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
        barGroups: chartData)),
  );
}
