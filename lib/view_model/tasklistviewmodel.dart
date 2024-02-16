import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoflutter/model/todolistmodel.dart';

import '../data/database.dart';
import '../util/dialog_box.dart';


class TaskListViewModel extends ChangeNotifier{

  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  TextEditingController controller=TextEditingController();
  int completeTasks=0;
   DateTime? selectedDate;
   TimeOfDay? selectedTime;
  String? selectedPriority;
  String? desc;
  bool isDarkEnabled=false;

  setIsDarkEnabled(bool value){
    if(isDarkEnabled){
      isDarkEnabled=false;
    }
    else{
      isDarkEnabled=value;
    }
    notifyListeners();
  }


   setSelectDateAndTime(DateTime s,TimeOfDay t,String sP,String d){
     selectedDate=s;
     selectedTime=t;
     selectedPriority=sP;
     desc=d;
     notifyListeners();

   }


   setCompletedTask(int v){
     completeTasks=v;
      notifyListeners();
   }
  checkData(BuildContext context){
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData(context);
    }
    // notifyListeners();
  }

  void editTask(int index) {
    final task = db.toDoList[index];

    // Update task details
    task.title = controller.text.trim();
    task.selectedDate = selectedDate!;
    task.selectedTime = selectedTime!;
    task.description = desc!; // Added line to update description

    // Update the database
    db.updateDataBase();

    // Clear the controller and selectedDate/selectedTime
    controller.clear();
    selectedDate = null;
    selectedTime = null;

    notifyListeners();
  }


  void checkBoxChanged(bool? value, int index) {
    if (value != null) {
      // Update task completion status and status text
      db.toDoList[index].taskCompleted = value;
      db.toDoList[index].status = value ? 'Completed' : 'Not Completed';

      // Update the completeTasks count
      if (value) {
        completeTasks++;
      } else {
        if (completeTasks != 0) {
          completeTasks--;
        }
      }

      // Update additionalParameter in the corresponding task
      db.toDoList[index].additionalParameter = completeTasks;

      // Update the database
      db.updateDataBase();
      notifyListeners();
    }
  }

   saveNewTask(String text,BuildContext context,DateTime selectedDate,
   TimeOfDay selectedTime,String desc,String prior) {
    db.toDoList.add(ToDoListModel(title: text, status: 'Not Complete', selectedDate: selectedDate, selectedTime: selectedTime, taskCompleted: false, additionalParameter: completeTasks,
    description: desc,priority: prior

    ));
    /// remeber to call this when function is called
    controller.clear();
    Navigator.of(context).pop();
    db.updateDataBase();
    notifyListeners();
  }
   createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: controller,
          onSave: (){
            saveNewTask(controller.text.trim(),context,selectedDate!,selectedTime!,desc!,selectedPriority!);
            controller.clear();
          },
          onCancel: () => Navigator.of(context).pop()
        );
      },
    );
    notifyListeners();
  }

  // delete task
  void deleteTask(int index) {
    db.toDoList.removeAt(index);
    db.updateDataBase();
    notifyListeners();
  }


}