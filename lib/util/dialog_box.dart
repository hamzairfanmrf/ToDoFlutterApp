import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoflutter/util/text_button.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function() onSave;
  final Function() onCancel;

  const DialogBox({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedPriority;
  TextEditingController desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: widget.controller,
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
              value: selectedPriority,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue;
                });
              },
              items: <String>['High Priority', 'Normal Priority']
                  .map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: const Text('Pick Date'),
            ),
            if (selectedDate != null)
              Text(
                'Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                style: TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time != null) {
                  setState(() {
                    selectedTime = time;
                  });
                }
              },
              child: const Text('Pick Time'),
            ),
            if (selectedTime != null)
              Text(
                'Time: ${selectedTime!.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      actions: [
        CommonTextButton(
          onPressed: () {
            // Navigator.of(context).pop();
            widget.onCancel();
          },
          buttonText: 'Cancel',

        ),
        CommonTextButton(  onPressed: () {
          if (widget.controller.text.trim().isEmpty ||
              selectedDate == null ||
              selectedTime == null ||
              selectedPriority == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in all fields.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            context.read<TaskListViewModel>().setSelectDateAndTime(selectedDate!, selectedTime!, selectedPriority!, desc.text.trim());
            // Pass selectedPriority and description to the onSave function
            widget.onSave();
          }
        }, buttonText: 'Save')

      ],
    );
  }
}
