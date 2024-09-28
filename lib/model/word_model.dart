import 'package:hive/hive.dart';

part 'word_model.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final String english;

  @HiveField(1)
  final String turkish;

  @HiveField(2)
  final DateTime date;

  Word({required this.english, required this.turkish, required this.date});
}
