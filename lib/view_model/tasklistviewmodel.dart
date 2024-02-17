import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoflutter/model/todolistmodel.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';

class TaskListViewModel extends GetxController {
  final ToDoDataBase db = ToDoDataBase.instance;
  TextEditingController controller = TextEditingController();
  RxInt completeTasks = 0.obs;
  RxString selectedPriority = 'High Priority'.obs;
  RxString? desc;
  RxBool isDarkEnabled = false.obs;
  final RxString _dropdownValue = 'All Items'.obs;
  final RxList<String> _priorityItems = <String>['High Priority', 'Normal Priority'].obs;

  RxList<String> get priorityItems => _priorityItems.toSet().toList().obs;

  Rx<TimeOfDay?> _selectedTime = TimeOfDay.now().obs;

  set selectedDate(DateTime? value) => _selectedDate.value = value!;
  set selectedTime(TimeOfDay? value) => _selectedTime.value = value;

  DateTime? get selectedDate => _selectedDate.value;
  TimeOfDay? get selectedTime => _selectedTime.value;

  void setSelectedTime(TimeOfDay newValue) {
    _selectedTime.value = newValue;
  }

  RxString get dropdownValue => _dropdownValue;

  // void setDropdownValue(String newValue) {
  //   // _dropdownValue.value = newValue;
  //   selectedPriority = newValue.obs;
  // }

  Rx<DateTime> _selectedDate = DateTime.now().obs;



  void setSelectedDate(DateTime newValue) {
    _selectedDate.value = newValue;
    update();
  }
  void setSelectedPriority(String pr){
    selectedPriority.value=pr;
    update();
  }

  setIsDarkEnabled(bool value) {
    isDarkEnabled.value = value;
  }

  setSelectDateAndTime(DateTime s, TimeOfDay t, String sP, String d) {
    _selectedDate = s.obs;
    _selectedTime.value = t;
    selectedPriority = sP.obs;
    desc = d.obs;
  }

  void checkData() {
    if (db.isBoxNull()) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  void editTask(int index,String text, DateTime selectedDate,
      TimeOfDay selectedTime, String desc, String prior) {
    final task = db.toDoList[index];
    task.title = text;
    task.selectedDate = selectedDate;
    task.selectedTime = selectedTime;
    task.description = desc;
    task.priority=prior;
    db.updateDataBase();
    controller.clear();


  }


  void checkBoxChanged(bool? value, int index) {
    if (value != null) {
      db.toDoList[index].taskCompleted = value;
      db.toDoList[index].status = value ? 'Completed' : 'Not Completed';
      if (value) {
        completeTasks.value++;
      } else {
        if (completeTasks.value != 0) {
          completeTasks.value--;
        }
      }
      db.toDoList[index].additionalParameter = completeTasks.value;
      update();
      db.updateDataBase();
    }
  }

  saveNewTask(String text, DateTime selectedDate,
      TimeOfDay selectedTime, String desc, String prior) {
    db.toDoList.add(ToDoListModel(
      title: text,
      status: 'Not Complete',
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      taskCompleted: false,
      additionalParameter: completeTasks.value,
      description: desc,
      priority: prior,
    ));
    controller.clear();
    setCompletedTasks(completeTasks.value);
    update();
    db.updateDataBase();



  }

  createNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(isEditMode: false, index: 0
        );
      },
    );
  }

  void setCompletedTasks(int v) {
    completeTasks.value = v;
  }

  void deleteTask(int index) {
    db.toDoList.removeAt(index);
    db.updateDataBase();
    update();
  }
}
