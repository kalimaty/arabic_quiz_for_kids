import 'package:flutter/material.dart';

import 'answered_item.dart';
import 'items.dart';

class Option extends StatefulWidget {
  const Option({
    Key? key,
    required this.word,
    required this.rightAns,
    required this.wrongAns,
    required this.answeredItems,
    required this.currentTime,
  }) : super(key: key);
  final AnsweredItems answeredItems;
  final String word;
  final VoidCallback rightAns;
  final VoidCallback wrongAns;
  final double currentTime;
  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  Color color = Color(0xFFcaa7ac);
  @override
  Widget build(BuildContext context) {
    return DragTarget<Item>(
      onWillAccept: (item) {
        return true;
      },
      onAccept: (item) {
        if (item.word == widget.word) {
          setState(() => color = Color(0xFF3b954a));
          widget.answeredItems.add(AnsweredItem(item, AnswerState.right));
          widget.rightAns();
        } else {
          setState(() => color = Color(0xFFb74330));
          widget.answeredItems.add(AnsweredItem(item, AnswerState.wrong));
          widget.wrongAns();
        }

        //          toNext(sound);
      },
      builder: (context, candidate, rejects) {
        return Container(
          alignment: Alignment(0, 0),
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Text(widget.word,
              style: const TextStyle(fontSize: 22, color: Color(0xFF1d1640))),
        );
      },
    );
  }
}
