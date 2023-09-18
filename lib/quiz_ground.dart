import 'dart:async';

import 'package:arabic_quiz_for_kids/answered_item.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
// import 'package:arabic_quiz_for_kids/av.dart';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'EachPage.dart';
// import 'animating_widget.dart';
import 'items.dart';
import 'score_screen.dart';

class QuizGround extends StatefulWidget {
  final String name;
  const QuizGround(this.name, {Key? key}) : super(key: key);

  @override
  _QuizGroundState createState() => _QuizGroundState();
}

class _QuizGroundState extends State<QuizGround> {
  late Items items;
  late AnsweredItems answeredItems;
  PageController pageController = PageController(initialPage: 0);
//  AudioPlayer audioPlayer = AudioPlayer();
  late String sound;
  late Item currentItem;
  int score = 0;
  bool isNotPressed = true;
  bool isNavigating = false;
  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    answeredItems = AnsweredItems();
    items = Items();
    items.initialized();

    super.initState();
  }
 
  play(String path) async {
   
    Audio.load(path)
      ..play()
      ..dispose();
    //  int result = await audioPlayer.play(path, isLocal: true);
  }

  toNext() {
    if (isNavigating) return;
    //this line play sound
    isNavigating = true;
    // play(sound);
    isNotPressed = false;
    setState(() {});
    //this 4 second for delay 4 second
    Future.delayed(Duration(milliseconds: 900)).then((value) {
      if (pageController.page == items.items.length - 1) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ScoreScreen(
                      score: score,
                      items: items,
                      answeredItems: answeredItems,
                      name: widget.name,
                    )),
            (route) => false);
      } else {
        pageController
            .nextPage(
                duration: Duration(milliseconds: 700), curve: Curves.easeOut)
            .then((value) {
          play(sound);
          isNavigating = false;
          isNotPressed = true;
        });
      }
//  اذا لم تكتمل الاسئلة  ظل انتقل للسؤال التالى فى الصفحة
    });
  }

  // toNext() {
  //   if (isNavigating) return;
  //   //this line play sound
  //   isNavigating = true;
  //   // play(sound);
  //   isNotPressed = false;
  //   setState(() {});
  //   //this 4 second for delay 4 second
  //   Future.delayed(Duration(seconds: 2)).then((value) {
  //     if (pageController.page == items.items.length - 1) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //               builder: (context) => ScoreScreen(
  //                     score: score,
  //                     items: items,
  //                     answeredItems: answeredItems,
  //                     name: widget.name,
  //                   )),
  //           (route) => false);
  //     }

  //     pageController
  //         .nextPage(
  //             duration: Duration(milliseconds: 200), curve: Curves.easeOut)
  //         .then((value) {
  //       play(sound);
  //       isNavigating = false;
  //       isNotPressed = true;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () {
                if (isNotPressed) {
                  isNotPressed = false;
                  answeredItems.add(
                    AnsweredItem(currentItem, AnswerState.skip),
                  );
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    toNext();
                  });

                  // السؤال التالى الصفحة التالية
                }
              },
              child: Text("Skip"),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: items.items.length,
            itemBuilder: (context, index) {
              sound = items.items[index].sound;
              currentItem = items.items[index]; //السؤال الحالى
              return EachPage(
                answeredItems: answeredItems,
                onRightAns: () {
                  score += 10;
                  toNext();
                  print(score);
                },
                onWrongAns: () {
                  toNext();
                  print(score);
                },
                items: items,
                index: index,
                toNext: toNext,
              );
            }));
  }
}
