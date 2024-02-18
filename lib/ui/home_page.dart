import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoflutter/ui/weather_page.dart';

import 'package:todoflutter/util/colors.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';

import '../util/dialog_box.dart';
import '../util/my_button.dart';
import '../util/todo_tile.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  late TaskListViewModel _controller;
  final  weatherController=Get.put(WeatherViewModel(),permanent: true);


  @override
  void initState() {
    super.initState();
    _controller = TaskListViewModel();
    _controller.checkData();

  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListViewModel>(
      init: TaskListViewModel(), // Initialize your controller here
      builder: (controller) {
        int completedTasks = controller.completeTasks.value;

        int totalTasks = controller.db.toDoList.length;

        double percentComplete = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
        bool isDarkModeEnabled = controller.isDarkEnabled.value;


        Color backgroundColor = isDarkModeEnabled ? AppColors.blackColor : AppColors.whiteColor;
        Color textColor = isDarkModeEnabled ? AppColors.whiteColor : AppColors.textColor;

        return Scaffold(
          backgroundColor: backgroundColor,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonElevatedButton(
                onPressed: () {
                  controller.createNewTask(context);
                },
                icon: Icons.add,
              ),

              const SizedBox(
                height: 5,
              ),
              CommonElevatedButton(
                onPressed: () async{
                  var location=await weatherController.determinePosition();
                  await weatherController.fetchWeather(location.latitude, location.longitude).then((value) => {

                  });

                  if(weatherController.weatherData.value!.weatherDescription.isNotEmpty){

                    Get.to(() =>  WeatherDisplay());

                  }
                },
                icon: Icons.cloud,
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
                                onTap: () {
                                  controller.setIsDarkEnabled(true);
                                },
                                child:  Text(
                                  "Dark Mode",
                                  style: TextStyle(color: textColor),
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
                                color: AppColors.whiteColor,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Text(
                              "${DateTime.now().day}th Feb",
                              style: const TextStyle(
                                color: AppColors.whiteColor,
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
                                color: AppColors.whiteColor,
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
                     Text('Sort By',
                    style: TextStyle(
                      color: textColor
                    ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.teal,
                          hint: const Text('Select Priority'),
                          value: controller.dropdownValue.value,
                          onChanged: (String? newValue) {
                            controller.dropdownValue.value = newValue!;
                            controller.update();
                          },
                          items: <String>['All Items', 'Completed', 'Not Completed']
                              .map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                  style: TextStyle(
                                      color: AppColors.whiteColor
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                ListView.builder(
                  itemCount: controller.db.toDoList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    bool displayItem = true;

                    if (controller.dropdownValue != 'All Items') {
                      displayItem = (controller.dropdownValue == 'Completed' &&
                          controller.db.toDoList[index].taskCompleted) ||
                          (controller.dropdownValue == 'Not Completed' &&
                              !controller.db.toDoList[index].taskCompleted);
                    }

                    return displayItem
                        ? ToDoTile(
                      taskName: controller.db.toDoList[index].title,
                      taskCompleted: controller.db.toDoList[index].taskCompleted,
                      onChanged: (value) => controller.checkBoxChanged(value, index),
                      deleteFunction: (context) => controller.deleteTask(index),
                      textColor: textColor,
                      editFunction: (BuildContext context, String s) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DialogBox(isEditMode: true, index: index,

                              // controller: controller.controller,
                              // onSave: () {
                              //   controller.editTask(index);
                              //   Navigator.of(context).pop();
                              // },
                              // onCancel: () => Navigator.of(context).pop(),
                            );
                          },
                        );
                      },
                      status: controller.db.toDoList[index].status,
                      dateTime: controller.db.toDoList[index].selectedDate,
                      description: controller.db.toDoList[index].description,
                      priority: controller.db.toDoList[index].priority,
                    )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
