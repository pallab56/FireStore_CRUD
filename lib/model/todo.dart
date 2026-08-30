import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String task;
  bool isDone;
  Timestamp createdOn;
  Timestamp updatedOn;
  Todo({
    required this.task,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
  });

  Todo copyWith({
    String? task,
    bool? isDone,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) => Todo(
    task: task ?? this.task,
    isDone: isDone ?? this.isDone,
    createdOn: createdOn ?? this.createdOn,
    updatedOn: updatedOn ?? this.updatedOn,
  );

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(
      task: json['task'] as String,
      isDone: json['isDone'] as bool,
      createdOn: json['createdOn'] as Timestamp,
      updatedOn: json['updatedOn'] as Timestamp,
    );
  }

  Map<String, Object?> toJson() => {
    'task': task,
    'isDone': isDone,
    'createdOn': createdOn,
    'updatedOn': updatedOn,
  };
}
