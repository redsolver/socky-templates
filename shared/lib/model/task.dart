import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  String id;

  String name;
  bool done;

  Task({this.name, this.done = false}) {
    id = Uuid().v4();
  }

  String get $key => id;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
