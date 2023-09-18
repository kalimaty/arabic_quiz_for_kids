import 'package:flutter/material.dart';

import '../bubble_background.dart';
import 'answered_item.dart';

class CheckSolution extends StatelessWidget {
  final AnsweredItems items;
  const CheckSolution({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF24575e),
      appBar: AppBar(
        backgroundColor: Color(0xFF18172d),
        title: Text("Solution"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: items.items
                .map((AnsweredItem e) => FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BubbleBackground(
                              colors: e.answerState == AnswerState.right
                                  ? [
                                      Color(0xFF245e46),
                                      Color(0xFF245e46),
                                    ]
                                  : e.answerState == AnswerState.wrong
                                      ? [
                                          Color(0xFF91382e),
                                          Color(0xFF91382e),
                                        ]
                                      : [
                                          Colors.teal,
                                          Colors.teal,
                                        ],
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Arabic: ${e.item.word}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BubbleBackground(
                              colors: [Color(0xFF805e39), Color(0xFF481e31)],
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Image.asset(
                                  e.item.image,
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
