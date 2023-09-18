import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'player_score.dart';
import 'quiz_ground.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerScoreAdapter());
  await Hive.openBox<PlayerScore>(SCORE_BOXS);

  runApp(const LearnArabicByQuizApp());
}

class LearnArabicByQuizApp extends StatelessWidget {
  const LearnArabicByQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LearnArabicByQuiz(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LearnArabicByQuiz extends StatelessWidget {
  LearnArabicByQuiz({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Your Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              controller: _controller,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty)
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => QuizGround(_controller.text)),
                    (route) => false);
            },
            child: Text("Start"),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
