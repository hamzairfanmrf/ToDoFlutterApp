import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/model/todolistmodel.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:provider/provider.dart';

class ToDoDataBase {
  List<ToDoListModel> toDoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [

    ];
  }

  // load the data from database
  void loadData(BuildContext context) {
    toDoList = (_myBox.get("TODOLIST") as List<dynamic>)
        .cast<ToDoListModel>();

    Future.delayed(Duration.zero, () {
      if(toDoList.isNotEmpty){
        context.read<TaskListViewModel>().setCompletedTask(toDoList[toDoList.length-1].additionalParameter);
      }
      else{
        context.read<TaskListViewModel>().setCompletedTask(0);
      }
    });
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList.cast<dynamic>());
  }

}
