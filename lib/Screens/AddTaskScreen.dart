import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tododraglist/models/TaskData.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String taskTitle;
  Color _color = Color(0xfff9a826);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: _color,
            ),
          ),
          TextField(
            autofocus: true,
            onChanged: (val) {
              taskTitle = val;
            },
          ),
          SizedBox(height: 10),
          FlatButton(
            onPressed: () {
              if (taskTitle != null && taskTitle.isNotEmpty) {
                Provider.of<TaskData>(context, listen: false)
                    .addTask(taskTitle);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
            color: _color,
          ),
        ],
      ),
    );
  }
}
