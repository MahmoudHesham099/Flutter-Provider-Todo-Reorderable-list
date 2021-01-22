import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tododraglist/Screens/AddTaskScreen.dart';
import 'package:tododraglist/models/Task.dart';
import 'package:tododraglist/models/TaskData.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _color = Color(0xfff9a826);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _color,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return AddTaskScreen();
              });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(
                    Icons.list,
                    size: 40,
                    color: _color,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Todo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${Provider.of<TaskData>(context).tasks.length} Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.white,
              child: Consumer<TaskData>(
                builder: (context, taskData, child) {
                  return ReorderableListView(
                    children: taskData.tasks
                        .map(
                          (task) => Container(
                            key: Key('${taskData.tasks.indexOf(task)}'),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _color, width: 1),
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: _color,
                                value: task.isDone,
                                onChanged: (checkbox) {
                                  taskData.updateTask(task);
                                },
                              ),
                              title: Text(
                                task.name,
                                style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  taskData.deleteTask(task);
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onReorder: (start, current) {
                      // drag from top to bottom
                      if (start < current) {
                        int end = current - 1;
                        Task startTask = taskData.tasks[start];
                        int i = 0;
                        int local = start;
                        do {
                          taskData.tasks[local] = taskData.tasks[++local];
                          i++;
                        } while (i < end - start);
                        taskData.tasks[end] = startTask;
                      }
                      // drag from bottom to top
                      if (start > current) {
                        Task startTask = taskData.tasks[start];
                        for (int i = start; i > current; i--) {
                          taskData.tasks[i] = taskData.tasks[i - 1];
                        }
                        taskData.tasks[current] = startTask;
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
