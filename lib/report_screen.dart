import 'package:flutter/material.dart';

import 'answered_item.dart';

class ReportScreen extends StatelessWidget {
  final AnsweredItems answeredItems;
  const ReportScreen({Key? key, required this.answeredItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Color(0xFF1c1f3c),
        appBar: AppBar(
          backgroundColor: Color(0xff446a6f),
          title: Text("Report Screen"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              ReportElement(
                constraints: constraints,
                name: 'Total Quiz',
                value: '${answeredItems.items.length}',
              ),
              ReportElement(
                constraints: constraints,
                name: 'Score',
                value: '${calRight() * 10}',
              ),
              ReportElement(
                constraints: constraints,
                name: 'Correct Answer',
                value: '${calRight()}/${answeredItems.items.length}',
              ),
              ReportElement(
                constraints: constraints,
                name: 'Incorrect Answer',
                value: '${calWrong()}/${answeredItems.items.length}',
              ),
              ReportElement(
                constraints: constraints,
                name: 'Not Answered',
                value: '${calNotAnswered()}/${answeredItems.items.length}',
              ),
            ],
          ),
        ),
      );
    });
  }

  calRight() {
    int i = 0;
    answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.right) {
        i++;
      }
    });
    return i;
  }

  calWrong() {
    int i = 0;
    answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.wrong) {
        i++;
      }
    });
    return i;
  }

  calNotAnswered() {
    int i = 0;
    answeredItems.items.forEach((element) {
      if (element.answerState == AnswerState.skip) {
        i++;
      }
    });
    return i;
  }
}

class ReportElement extends StatelessWidget {
  final BoxConstraints constraints;
  final String name;
  final String value;
  const ReportElement({
    Key? key,
    required this.constraints,
    required this.name,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF6d7d7d).withOpacity(0.4)),
      margin: EdgeInsets.all(20),
      height: constraints.maxHeight * 0.12,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
