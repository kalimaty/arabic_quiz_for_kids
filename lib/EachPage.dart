import 'dart:async';

import 'package:flutter/material.dart';

import 'Option.dart';
import 'animating_widget.dart';
import 'answered_item.dart';
import 'items.dart';
// import 'quiz_ground.dart';

class EachPage extends StatefulWidget {
  const EachPage({
    Key? key,
    required this.items,
    required this.index,
    required this.onRightAns,
    required this.onWrongAns,
    required this.answeredItems,
    required this.toNext,
  }) : super(key: key);
  final VoidCallback toNext;
  final int index;
  final Items items;
  final VoidCallback onRightAns;
  final VoidCallback onWrongAns;
  final AnsweredItems answeredItems;
  @override
  State<EachPage> createState() => _EachPageState();
}

class _EachPageState extends State<EachPage> {
  double totalTime = 16;
  double currentTime = 0;
  bool isAnswered = false;
  bool isComplete = false;
  late Timer timer;
  late Items item;
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  resetConfirmation() async {
    showDialog(
        barrierColor: Colors.black54,
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return AnimateTheWidget(
            needAnimate: true,
            onEnd: () {},
            child: AlertDialog(
              alignment: Alignment.topCenter,
              actionsAlignment: MainAxisAlignment.center,
              backgroundColor: Colors.green,
              icon: Icon(Icons.skip_next),
              shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(25.0)),
              content: Text(
                "Go to the next question or try again ?",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      widget.toNext();
                      widget.answeredItems.add(AnsweredItem(
                          widget.items.items[widget.index], AnswerState.skip));

                      // Navigator.of(dialogContext).pop();
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                    },
                    icon: Icon(Icons.arrow_circle_right,
                        size: 50, color: Colors.black)),
                SizedBox(
                  width: 100,
                ),
                IconButton(
                    onPressed: () {
                      currentTime = totalTime;
                      Future.delayed(Duration(milliseconds: 50)).then((value) {
                        timer = Timer.periodic(Duration(seconds: 1), (timer) {
                          if (currentTime <= 0) timer.cancel();
                          totalTime = 15;

                          setState(() {
                            currentTime -= 1;
                          });
                        });
                      });

                      // Navigator.of(dialogContext).pop();
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                    },
                    icon: Icon(Icons.refresh_outlined,
                        size: 50, color: Colors.black)),
              ],
            ),
          );
        });
  }

  @override
  initState() {
    currentTime = totalTime;
    item = Items();
    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      //if mounted
      // if(mounted){}
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (currentTime <= 0) {
          timer.cancel();

          resetConfirmation();
        } else {
          currentTime -= 1;

          setState(() {});
        }
        ;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            //مؤشر الوقت التنازلى الشريط
            child: LinearProgressIndicator(
              value: currentTime / totalTime,
              backgroundColor: Colors.amber,
              color: Colors.red,
            ),
          ),
        ),
        Text("${currentTime}"), // التايمر العددى
        RichText(
          text: TextSpan(children: [
            //السؤال رقم كم الان من مجموع الاسئلة
            TextSpan(text: " ${widget.index + 1} /"),
            TextSpan(
                text: "${widget.items.items.length}",
                style: const TextStyle(fontSize: 18)),
          ], style: const TextStyle(fontSize: 26, color: Color(0xFF3a3b6b))),
        ),
        Expanded(
          child: Row(
            children: [
              const Spacer(
                flex: 1,
              ),
//3 حالات  يتم تجميد عنصر الدراجابل
              if (isAnswered || currentTime == 0 || currentTime > 15)
                SizedBox(
                    height: 120,
                    width: 120,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image.asset(
                        widget.items.items[widget.index].image,
                        fit: BoxFit.fill,
                      ),
                    ))
              else
                Draggable<Item>(
                  data: widget.items.items[widget.index],
                  // شكل العنصر اثناء السحب
                  feedback: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      widget.items.items[widget.index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  //العنصر الاصلى الصورة
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      widget.items.items[widget.index].image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  childWhenDragging: SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      widget.items.items[widget.index].image,
                      fit: BoxFit.fill,
                      color: Colors.grey.withOpacity(0.2),
                      colorBlendMode: BlendMode.saturation,
                    ),
                  ),
                ),
              const Spacer(
                flex: 2,
              ),
              // عمود الكلمات على يمين الشاشة
              Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // الاختيارات  الكلات وتوقيت دخولها للشاشة بفواصل زمنية بين كل عنصر
                  children: [
                    AnimateTheWidget(
                      needAnimate: true,
                      onEnd: () {},
                      child: Option(
                        word: widget.items.items[widget.index].options[0],
                        rightAns: () {
                          if (isAnswered) return; //
                          widget.onRightAns(); //دى جاية منeachPage
                          setState(() => isAnswered =
                              true); //منع الاجابة  بعد  سحب الصورة وافلاتها
                        },
                        wrongAns: () {
                          if (isAnswered) return;
                          widget.onWrongAns();
                          setState(() => isAnswered = true);
                        },
                        answeredItems:
                            widget.answeredItems, //تسجيل حالة الاجابة الان
                        currentTime: currentTime, // الوقت الحالى
                      ),
                    ),
                    FutureBuilder<Widget>(
                        future: Future.delayed(Duration(milliseconds: 500), () {
                          return AnimateTheWidget(
                            needAnimate: true,
                            onEnd: () {},
                            child: Option(
                              word: widget.items.items[widget.index].options[1],
                              rightAns: () {
                                if (isAnswered) return;
                                widget.onRightAns();
                                setState(() => isAnswered = true);
                              },
                              wrongAns: () {
                                if (isAnswered) return;
                                widget.onWrongAns();
                                setState(() => isAnswered = true);
                              },
                              answeredItems: widget.answeredItems,
                              currentTime: currentTime,
                            ),
                          );
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          }
                          return SizedBox(
                            height: 120,
                            width: 120,
                          );
                        }),
                    FutureBuilder<Widget>(
                        future:
                            Future.delayed(Duration(milliseconds: 1000), () {
                          return AnimateTheWidget(
                            needAnimate: true,
                            onEnd: () {},
                            child: Option(
                              word: widget.items.items[widget.index].options[2],
                              rightAns: () {
                                if (isAnswered) return;
                                widget.onRightAns();
                                setState(() => isAnswered = true);
                              },
                              wrongAns: () {
                                if (isAnswered) return;
                                widget.onWrongAns();
                                setState(() => isAnswered = true);
                              },
                              answeredItems: widget.answeredItems,
                              currentTime: currentTime,
                            ),
                          );
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          }
                          return SizedBox(
                            height: 120,
                            width: 120,
                          );
                        }),
                    FutureBuilder<Widget>(
                        future:
                            Future.delayed(Duration(milliseconds: 1500), () {
                          return AnimateTheWidget(
                            needAnimate: true,
                            onEnd: () {},
                            child: Option(
                              word: widget.items.items[widget.index].options[3],
                              rightAns: () {
                                if (isAnswered) return;
                                widget.onRightAns();
                                setState(() => isAnswered = true);
                              },
                              wrongAns: () {
                                if (isAnswered) return;
                                widget.onWrongAns();
                                setState(() => isAnswered = true);
                              },
                              answeredItems: widget.answeredItems,
                              currentTime: currentTime,
                            ),
                          );
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          }
                          return SizedBox(
                            height: 120,
                            width: 120,
                          );
                        }),
                  ]
                  //  widget.items.items[widget.index].options.map((word) {
                  //   int i = widget.items.items[widget.index].options
                  //       .indexWhere((e) => e == word);
                  //   print(i);
                  //   return AnimateTheWidget(
                  //     needAnimate: true,
                  //     onEnd: () {},
                  //     child: Option(
                  //       word: word,
                  //       rightAns: () {
                  //         if (isAnswered) return;
                  //         widget.onRightAns();
                  //         setState(() => isAnswered = true);
                  //       },
                  //       wrongAns: () {
                  //         if (isAnswered) return;
                  //         widget.onWrongAns();
                  //         setState(() => isAnswered = true);
                  //       },
                  //       answeredItems: widget.answeredItems,
                  //     ),
                  //   );
                  // }).toList(),
                  ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
