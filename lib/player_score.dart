import 'package:hive/hive.dart';
part 'player_score.g.dart';

const SCORE_BOXS = 'ArabicQuizScoreBoxes';

@HiveType(typeId: 0)
class PlayerScore {
  @HiveField(0)
  String name;
  @HiveField(1)
  int score;
  @HiveField(2)
  int examNumber;
  @HiveField(3)
  String date;
  PlayerScore(
      {required this.examNumber,
      required this.name,
      required this.score,
      required this.date});
}
