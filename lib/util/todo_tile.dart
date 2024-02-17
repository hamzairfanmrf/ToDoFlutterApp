import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoflutter/util/colors.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String status;
  final DateTime dateTime;
  final String description; // New field for description
  final String priority; // New field for priority
  final Color textColor;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext, String)? editFunction;

  ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
    required this.status,
    required this.dateTime,
    required this.description, // Include description in the constructor
    required this.priority, // Include priority in the constructor
    required this.textColor
  }) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = taskName;

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        startActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            // Edit action
            SlidableAction(
              onPressed: (BuildContext context) {
                editFunction?.call(context, taskName);
                _controller.text = taskName;
              },
              icon: Icons.edit,
              backgroundColor: AppColors.blueColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            // Delete action
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.yellowColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(

            children: [
              Row(
                children: [
                  // Checkbox
                  Checkbox(
                    value: taskCompleted,
                    onChanged: onChanged,
                    activeColor: AppColors.blackColor,
                  ),

                  // Task name
                  Text(
                    taskName,
                    style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: textColor
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      child: Text('Description: $description',
                      style: TextStyle(
                          color: textColor
                      ),

                      )), // Display description

                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text('Priority: $priority',
                  style: TextStyle(
                    color: priority=="High Priority"?Colors.red:Colors.green
                  ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Text('${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: TextStyle(
                      color: textColor
                  ),

                  ),

                  // Status
                  Container(
                    decoration: BoxDecoration(
                      color: status == "Completed" ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(status),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
