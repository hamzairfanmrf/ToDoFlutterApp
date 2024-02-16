import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String status;
  final DateTime dateTime;
  final String description; // New field for description
  final String priority; // New field for priority
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext, String)? editFunction;

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
  }) : super(key: key);

  TextEditingController _controller = TextEditingController();

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
              backgroundColor: Colors.blue,
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
            color: Colors.yellow,
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
                    activeColor: Colors.black,
                  ),

                  // Task name
                  Text(
                    taskName,
                    style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width/2,
                      child: Text('Description: $description')), // Display description

                ],
              ),
              SizedBox(
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
                  Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),

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
