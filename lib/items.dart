import 'dart:math';

class Items {
  List<Item> items = []; // items = _items;

  initialized() {
    List<Item> _items = [];
    for (int i = 1; i < 8; i++) {
      Item ie = Item(i);
      ie.initialize();
      _items.add(ie);
    }
    _items.shuffle();
    items = _items;
    print(items.length);
  }
}

class Item {
  int index;
  Item(this.index);
  String get word => words[index - 1];
  String get image => "assets/images/$index.png";
  String get sound => "assets/sounds/$index.mp3";
  List<String> options = [];

  initialize() {
    Random rand = Random();
    List l = [
      "lion",
      "Duck",
      "An apple",
      "snake",
      "Gamal",
      "pigeon",
      "Lamb",
      "Bear",
      "corn",
      "a leg",
      " giraffe",
      "fish",
      "tree",
      "Samdouk",
      "frog",
      "peacock",
      "Circumstance",
      "Flag",
      "deer",
      "frolly",
      "Monkey",
      "dog",
      "Lemon",
      "banana",
      "Bee",
      "pyramid",
      "rose",
      "hand"
    ];
    l.remove(word);
    String op1 = l[rand.nextInt(26)];
    l.remove(op1);
    String op2 = l[rand.nextInt(25)];
    l.remove(op2);
    String op3 = l[rand.nextInt(24)];
    List<String> listOfOp = [word, op1, op2, op3];
    listOfOp.shuffle();
    options = listOfOp;
  }
}

List words = [
  "lion",
  "Duck",
  "An apple",
  "snake",
  "Gamal",
  "pigeon",
  "Lamb",
  "Bear",
  "corn",
  "a leg",
  " giraffe",
  "fish",
  "tree",
  "Samdouk",
  "frog",
  "peacock",
  "Circumstance",
  "Flag",
  "deer",
  "frolly",
  "Monkey",
  "dog",
  "Lemon",
  "banana",
  "Bee",
  "pyramid",
  "rose",
  "hand",
];
