
import 'package:hive/hive.dart';
part 'todoModel.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  
  @HiveField(0)
  final topic;
  
  @HiveField(1)
  final description;

  TodoModel({this.topic,this.description});
}