
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoflutter/data/adapter.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoListModelAdapter());

  group('TaskListViewModel', () {

    late TaskListViewModel taskListViewModel;

    setUp(() async{
      await Hive.openBox('mybox');
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

      await weatherViewModel.fetchWeather(41.0082, 28.9784);

      final weatherData = weatherViewModel.weatherData.value;

      expect(weatherData, isNotNull);
      expect(weatherData?.temperature, isNotNull);
      expect(weatherData?.weatherDescription, isNotNull);
    });
  });
}
