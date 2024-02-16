import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/todolistmodel.dart';

class ToDoListModelAdapter extends TypeAdapter<ToDoListModel> {
  @override
  int get typeId => 0; // Unique identifier for your model

  @override
  ToDoListModel read(BinaryReader reader) {
    var map = reader.readMap();
    return ToDoListModel(
      title: map['title'] as String,
      status: map['status'] as String,
      selectedDate: DateTime.parse(map['selectedDate'] as String),
      selectedTime: TimeOfDay(
        hour: map['selectedTime']['hour'] as int,
        minute: map['selectedTime']['minute'] as int,
      ),
      taskCompleted: map['taskCompleted'] as bool,
      additionalParameter: map['additionalParameter'] as int? ?? 0,
      description: map['description'] as String? ?? '', // Read description from the map
      priority: map['priority'] as String? ?? 'Normal Priority', // Read priority from the map
    );
  }

  @override
  void write(BinaryWriter writer, ToDoListModel obj) {
    writer.writeMap(obj.toJson());
  }
}
