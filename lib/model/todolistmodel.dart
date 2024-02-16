import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ToDoListModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String status;

  @HiveField(2)
  DateTime selectedDate;

  @HiveField(3)
  TimeOfDay selectedTime;

  @HiveField(4)
  bool taskCompleted;

  @HiveField(5)
  int additionalParameter; // Additional parameter for completeTasks

  @HiveField(6) // New field: Priority
  String priority;

  @HiveField(7) // New field: Description
  String description;

  ToDoListModel({
    required this.title,
    required this.status,
    required this.selectedDate,
    required this.selectedTime,
    required this.taskCompleted,
    required this.additionalParameter,
    required this.priority,
    required this.description,
  });

  factory ToDoListModel.fromJson(Map<String, dynamic> json) {
    return ToDoListModel(
      title: json['title'],
      status: json['status'],
      selectedDate: DateTime.parse(json['selectedDate']),
      selectedTime: TimeOfDay(
        hour: json['selectedTime']['hour'],
        minute: json['selectedTime']['minute'],
      ),
      taskCompleted: json['taskCompleted'],
      additionalParameter: json['additionalParameter'],
      priority: json['priority'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': status,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': {
        'hour': selectedTime.hour,
        'minute': selectedTime.minute,
      },
      'taskCompleted': taskCompleted,
      'additionalParameter': additionalParameter,
      'priority': priority,
      'description': description,
    };
  }
}
