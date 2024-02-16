import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/ui/weather_page.dart';
import 'package:todoflutter/util/colors.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'All Items'; // Default value for dropdown

  @override
  void initState() {
    context.read<TaskListViewModel>().checkData(context);
    super.initState();
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int completedTasks = context.watch<TaskListViewModel>().completeTasks;
    int totalTasks = context.watch<TaskListViewModel>().db.toDoList.length;

    double percentComplete = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    bool isDarkModeEnabled = context.watch<TaskListViewModel>().isDarkEnabled;
    Color backgroundColor = isDarkModeEnabled ? AppColors.blackColor : AppColors.whiteColor;
    Color textColor = isDarkModeEnabled ? AppColors.whiteColor : AppColors.textColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<TaskListViewModel>().createNewTask(context);
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.primaryColor , // Background color
              shape: CircleBorder(), // Circular shape
              padding: EdgeInsets.all(16), // Padding around the icon
            ),
            child: Icon(Icons.add, color: AppColors.whiteColor),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: () async {
              var location = await context.read<WeatherViewModel>().determinePosition();
              context.read<WeatherViewModel>().fetchWeather(location.latitude, location.longitude);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherDisplay()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF675DFB), // Background color
              shape: CircleBorder(), // Circular shape
              padding: EdgeInsets.all(16), // Padding around the icon
            ),
            child: Icon(Icons.cloud, color: AppColors.whiteColor),
          ),

        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: AppColors.whiteColor,
                          ),
                          InkWell(
                            onTap: (){
                              context.read<TaskListViewModel>().setIsDarkEnabled(true);
                            },
                            child: const Text("Dark Mode",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "${DateTime.now().day}th Feb",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$completedTasks Tasks',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          width: 3,
                          color: AppColors.whiteColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          'Completed',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearPercentIndicator(
                          width: 180.0,
                          lineHeight: 14.0,
                          percent: percentComplete,
                          backgroundColor: Colors.grey,
                          progressColor: AppColors.whiteColor,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sort By'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.yellowColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['All Items', 'Completed', 'Not Completed']
                          .map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: context.watch<TaskListViewModel>().db.toDoList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              itemBuilder: (context, index) {
                // Filter the list based on the dropdown value
                bool displayItem = true;

                if (dropdownValue != 'All Items') {
                  displayItem = (dropdownValue == 'Completed' &&
                      context.watch<TaskListViewModel>().db.toDoList[index].taskCompleted) ||
                      (dropdownValue == 'Not Completed' &&
                          !context.watch<TaskListViewModel>().db.toDoList[index].taskCompleted);
                }

                return displayItem
                    ? ToDoTile(
                  taskName: context.watch<TaskListViewModel>().db.toDoList[index].title,
                  taskCompleted: context.watch<TaskListViewModel>().db.toDoList[index].taskCompleted,
                  onChanged: (value) => context.read<TaskListViewModel>().checkBoxChanged(value, index),
                  deleteFunction: (context) => context.read<TaskListViewModel>().deleteTask(index),
                  editFunction: (BuildContext context, String s) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogBox(
                          controller: context.read<TaskListViewModel>().controller,
                          onSave: () {
                            context.read<TaskListViewModel>().editTask(index);
                            Navigator.of(context).pop();
                          },
                          onCancel: () => Navigator.of(context).pop(),
                        );
                      },
                    );
                  },
                  status: context.watch<TaskListViewModel>().db.toDoList[index].status,
                  dateTime: context.watch<TaskListViewModel>().db.toDoList[index].selectedDate, description: context.watch<TaskListViewModel>().db.toDoList[index].description,
                  priority: context.watch<TaskListViewModel>().db.toDoList[index].priority,
                )
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
