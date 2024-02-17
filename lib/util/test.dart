
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';

import '../view_model/weatherViewModel.dart';

void main() {
  group('TaskListViewModel', () {
    late TaskListViewModel taskListViewModel;

    setUp(() {
      taskListViewModel = TaskListViewModel();
    });

    test('Insert Task', () {
      final initialLength = taskListViewModel.db.toDoList.length;
      taskListViewModel.saveNewTask(
        'Test Task',
        DateTime.now(),
        TimeOfDay.now(),
        'Test Description',
        'High',
      );

      final updatedLength = taskListViewModel.db.toDoList.length;

      expect(updatedLength, equals(initialLength + 1));
    });

    test('Delete Task', () {
      taskListViewModel.saveNewTask(
        'Test Task',
        DateTime.now(),
        TimeOfDay.now(),
        'Test Description',
        'High',
      );

      final initialLength = taskListViewModel.db.toDoList.length;
      taskListViewModel.deleteTask(0);

      final updatedLength = taskListViewModel.db.toDoList.length;

      expect(updatedLength, equals(initialLength - 1));
    });

    test('Edit Task', () {
      taskListViewModel.saveNewTask(
        'Test Task',
        DateTime.now(),
        TimeOfDay.now(),
        'Test Description',
        'High',
      );

      taskListViewModel.editTask(  0, 'Updated Task',
        DateTime.now(),
        TimeOfDay.now(),
        'Updated Description',
        'High');

      final editedTask = taskListViewModel.db.toDoList[0];

      expect(editedTask.title, equals('Updated Task'));
      expect(editedTask.description, equals('Updated Description'));
      expect(editedTask.priority, equals('High'));
    });
  });

  group('WeatherViewModel', () {
    late WeatherViewModel weatherViewModel;

    setUp(() {
      weatherViewModel = WeatherViewModel();
    });

    test('Fetch Weather', () async {
      final position = await weatherViewModel.determinePosition();
      await weatherViewModel.fetchWeather(position.latitude, position.longitude);

      final weatherData = weatherViewModel.weatherData.value;

      expect(weatherData, isNotNull);
      expect(weatherData?.temperature, isNotNull);
      expect(weatherData?.weatherDescription, isNotNull);
    });
  });
}
