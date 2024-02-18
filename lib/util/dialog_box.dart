import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todoflutter/util/text_button.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';

import 'my_button.dart';

class DialogBox extends StatefulWidget {
  final bool isEditMode;
  final int index;

  DialogBox({Key? key, required this.isEditMode,required this.index}) : super(key: key);
  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final TextEditingController controller = TextEditingController();

  final TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskListController = Get.find<TaskListViewModel>();

    return Obx(() =>AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: desc,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Select Priority'),
              value: taskListController.selectedPriority.value,
              onChanged: (String? newValue) {
                taskListController.setSelectedPriority(newValue!);
                // taskListController.update(); // Update the UI
              },
              items: taskListController.priorityItems
                  .map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              )
                  .toList(),
            ),




            const SizedBox(height: 20),
            CommonElevatedButton(
              onPressed: () async {
              final DateTime? date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (date != null) {
                taskListController.setSelectedDate(date);
              }
            },
              txt: "Pick Date", isFromHome: false,

            ),
            if (taskListController.selectedDate != null)
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(taskListController.selectedDate!)}',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            CommonElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  taskListController.setSelectedTime(time);
                }
              },
              txt: "Pick Time", isFromHome: false,

            ),

            if (taskListController.selectedTime != null)
              Text(
                'Time: ${taskListController.selectedTime!.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      actions: [
        CommonTextButton(
          onPressed: () {

            Navigator.of(context).pop();
          },
          buttonText: 'Cancel',
        ),
        CommonTextButton(
          onPressed: () {
            if (controller.text.trim().isEmpty ||desc.text.isEmpty||
                taskListController.selectedDate == null ||
                taskListController.selectedTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all fields.'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              if (widget.isEditMode) {
                // If in edit mode, call the editTask method
                taskListController.editTask(widget.index, controller.text.trim(),

                  taskListController.selectedDate!,
                  taskListController.selectedTime!,
                  desc.text.trim(),
                  taskListController.selectedPriority.value);
               taskListController.update();
                Navigator.of(context).pop();
              }
              else{
                taskListController.saveNewTask(
                  controller.text.trim(),

                  taskListController.selectedDate!,
                  taskListController.selectedTime!,
                  desc.text.trim(),
                  taskListController.selectedPriority.value,
                );
                Navigator.of(context).pop();

              }
              controller.clear();
            }
          },
          buttonText: 'Save',
        ),
      ],
    ));
  }
}
