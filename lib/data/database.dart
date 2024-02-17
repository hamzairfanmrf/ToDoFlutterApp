
import 'package:hive/hive.dart';
import 'package:todoflutter/model/todolistmodel.dart';

class ToDoDataBase {
  late List<ToDoListModel> toDoList;
  late final Box<dynamic> _myBox;

  // Create a private constructor
  ToDoDataBase._() {
    toDoList = [];
    _myBox = Hive.box('mybox');
  }

  // Create a static instance of the class
  static final ToDoDataBase _instance = ToDoDataBase._();

  // Create a getter to access the instance
  static ToDoDataBase get instance => _instance;



  void createInitialData() {
    toDoList = [];
  }
  bool isBoxNull() {
    return _myBox.get("TODOLIST") == null;
  }

  void loadData() {
    if (_myBox.containsKey("TODOLIST")) {
      toDoList = (_myBox.get("TODOLIST") as List<dynamic>)
          .cast<ToDoListModel>();
    } else {
      // Handle the case when "TODOLIST" key is not present in the box
      toDoList = [];
    }
  }


  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList.cast<dynamic>());

  }
}
