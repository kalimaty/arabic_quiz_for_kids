import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'player_score.dart';

class LeaderBoard extends StatefulWidget {
  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Box<PlayerScore> scoreBox = Hive.box<PlayerScore>(SCORE_BOXS);

  List<PlayerScore> top5 = [];

  Map<dynamic, PlayerScore> deletedBox = {};

  undoReset() async {
    await scoreBox.putAll(deletedBox);
    top5update();
    print(scoreBox.length);
  }

  resetScores() async {
    scoreBox.toMap().forEach((key, value) {
      deletedBox[key] = value;
    });
    await scoreBox.clear();
    top5update();
  }

  top5update() {
    List<PlayerScore> emptyLP = [];
    scoreBox.toMap().forEach((key, value) {
      emptyLP.add(value);
    });
    emptyLP = emptyLP..sort((a, b) => b.score.compareTo(a.score));
    if (emptyLP.length < 5) {
      top5 = emptyLP.sublist(0, emptyLP.length);
    } else {
      top5 = emptyLP.sublist(0, 5);
    }
    setState(() {});
  }

  @override
  void initState() {
    top5update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF24413d),
      appBar: AppBar(
        backgroundColor: Color(0xFF3a6a74),
        title: Text("Score Screen"),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<PlayerScore>(SCORE_BOXS).listenable(),
          builder: (context, Box<PlayerScore> box, child) {
            return DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        PopupMenuButton(
                            icon: Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) {
                              return box.isNotEmpty
                                  ? [
                                      PopupMenuItem(
                                        onTap: () {
                                          resetScores();
                                        },
                                        height: 10,
                                        child: Text("Reset"),
                                      ),
                                    ]
                                  : [
                                      PopupMenuItem(
                                        onTap: () {
                                          undoReset();
                                        },
                                        height: 10,
                                        child: Text("Undo"),
                                      ),
                                    ];
                            }),
                      ],
                    ),
                    Expanded(child: ChartScreen(playerScores: top5))
                  ],
                ),
              ),
            );
          }),
    );
  }
}

// ignore: must_be_immutable
class ChartScreen extends StatelessWidget {
  ChartScreen({required this.playerScores});
  final List<PlayerScore> playerScores;
  TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(
        isVisible: true,
        textStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      tooltipBehavior: tooltipBehavior,
      title: ChartTitle(
        text: "Scores in subjects",
        textStyle: TextStyle(color: Colors.white),
      ),
      primaryYAxis: NumericAxis(
        maximum: 100,
        labelStyle: TextStyle(color: Colors.white),
        title: AxisTitle(
          text: 'Score in Percentage',
          textStyle: TextStyle(
              color: Colors.yellow,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.white),
        labelAlignment: LabelAlignment.center,
        title: AxisTitle(
          text: 'Name',
          textStyle: TextStyle(
              color: Colors.yellow,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      ),
      series: <ChartSeries>[
        StackedColumnSeries<PlayerScore, String>(
          dataSource: playerScores,
          xValueMapper: (PlayerScore playerScore, int index) {
            return playerScore.name;
          },
          yValueMapper: (PlayerScore playerScore, int index) {
            return (playerScore.score / playerScore.examNumber) * 100;
          },
          name: "Score",
          color: Colors.blue,
        ),
      ],
    );
  }
}
