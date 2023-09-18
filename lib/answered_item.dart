import 'items.dart';

enum AnswerState { right, wrong, skip }

class AnsweredItems {
  List<AnsweredItem> items = [];

  add(AnsweredItem item) {
    items.add(item);
  }
}

class AnsweredItem {
  Item item;
  AnswerState answerState; //{ right, wrong, skip }
  AnsweredItem(this.item, this.answerState);
}
