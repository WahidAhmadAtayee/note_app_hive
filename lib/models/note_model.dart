import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class Note {
  Note(this.text, this.des);

  @HiveField(0)
  String text;
  // 
  @HiveField(1)
  String des;
}
