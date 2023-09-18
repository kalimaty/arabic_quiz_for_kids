import 'package:arabic_quiz_for_kids/answered_item.dart';
import 'package:arabic_quiz_for_kids/player_score.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import '../items.dart';
import 'check_solution.dart';
import 'highscore_screen.dart';
import 'leaderboard.dart';
import 'main.dart';
import 'report_screen.dart';

class ScoreScreen extends StatefulWidget {
  final String name;
  final int score;
  final Items items;
  final AnsweredItems answeredItems;
  const ScoreScreen({
    Key? key,
    required this.score,
    required this.items,
    required this.answeredItems,
    required this.name,
  }) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  Box<PlayerScore> scoreBox = Hive.box<PlayerScore>(SCORE_BOXS);

  @override
  void initState() {
    var date = DateTime.now();
    int year = date.year;
    int month = date.month;
    int day = date.day;
        String hour =
        "${date.hour > 11 ? date.hour - 12 : date.hour}${date.hour > 11 ? "pm" : "am"}";
    String dateOfPlaying = "$year-${months[month - 1]}-$day-$hour";

    scoreBox.put(
        widget.name,
        PlayerScore(
            name: widget.name,
            score: widget.score,
            examNumber: widget.items.items.length * 10,
            date: dateOfPlaying));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF27273e),
      appBar: AppBar(
        backgroundColor: Color(0xFF476767),
        title: Text("Score Screen"),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DefaultTextStyle(
              style: TextStyle(color: Colors.white),
              child: PieChart(
                dataMap: {
                  "Right": rightAnsCount(),
                  "Skip": skipCount(),
                  "Wrong": wrongAnsCount(),
                },
                animationDuration: Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 1.5,
                colorList: [Colors.green, Colors.tealAccent, Colors.redAccent],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText:
                    "Score ${widget.score}/${widget.items.items.length * 10}",
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: MaterialButton(
                height: constraints.maxHeight * 0.1,
                minWidth: constraints.maxWidth * 0.6,
                color: Color(0xFF899390),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CheckSolution(
                        items: widget.answeredItems,
                      ),
                    ),
                  );
                },
                child: Text("Check Solution"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    height: constraints.maxHeight * 0.1,
                    minWidth: constraints.maxWidth * 0.4,
                    color: Color(0xFF899390),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LeaderBoard(),
                        ),
                      );
                    },
                    child: Text("LeaderBoard"),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    height: constraints.maxHeight * 0.1,
                    minWidth: constraints.maxWidth * 0.4,
                    color: Color(0xFF899390),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HighScoreScreen(),
                        ),
                      );
                    },
                    child: Text("Heigh Scores"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    height: constraints.maxHeight * 0.1,
                    minWidth: constraints.maxWidth * 0.4,
                    color: Color(0xFF899390),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportScreen(
                            answeredItems: widget.answeredItems,
                          ),
                        ),
                      );
                    },
                    child: Text("Report"),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MaterialButton(
                    height: constraints.maxHeight * 0.1,
                    minWidth: constraints.maxWidth * 0.4,
                    color: Color(0xFF899390),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LearnArabicByQuiz()),
                          (route) => false);
                    },
                    child: Text("Home"),
                  ),
                ),
              ],
            ),
            Container(),
          ],
        );
      }),
    );
  }

  double percentageRightAns(Items items, int score) {
    double total = items.items.length.toDouble();
    double right = score / 10;

    return (right / total);
  }

  double rightAnsCount() {
    double i = 0;
    widget.answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.right) {
        i++;
      }
    });
    return i;
  }

  double wrongAnsCount() {
    double i = 0;
    widget.answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.wrong) {
        i++;
      }
    });
    return i;
  }

  double skipCount() {
    double i = 0;
    widget.answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.skip) {
        i++;
      }
    });
    return i;
  }
}

const List months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
