import 'package:flutter/material.dart';

import 'package:client/root.client.dart';
import 'package:shared/model/task.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socky Tasks Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskHomePage(title: 'Tasks Home Page'),
    );
  }
}

class TaskHomePage extends StatefulWidget {
  TaskHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  // Server URLs for Development
  // Web and iOS Simulator: http://localhost:8080
  // Android Emulator: http://10.0.2.2:8080
  // External device: http://<ip-address>:8080 (Don't forget to set your firewall settings in this case)
  final client =
      RootClient(baseUrl: 'http://10.0.2.2:8080'); // TODO Set address

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    tasks = await client.listTasks();
    setState(() {});
  }

  List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: tasks == null
          ? LinearProgressIndicator()
          : ListView(
              children: <Widget>[
                for (var task in tasks)
                  CheckboxListTile(
                    title: Text(
                      task.name,
                      style: TextStyle(
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    value: task.done,
                    onChanged: (val) {
                      setState(() {
                        task.done = val;
                        client.setTaskState(task.id, val);
                      });
                    },
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final _ctrl = TextEditingController();

          final val = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Create task'),
                    content: TextField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      controller: _ctrl,
                      autofocus: true,
                      onSubmitted: (val) => Navigator.of(context).pop(val),
                    ),
                    actions: [
                      FlatButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text('Cancel'),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(_ctrl.text),
                        child: Text('Create'),
                      ),
                    ],
                  ));

          if (val != null) {
            final newTask = await client.createTask(val);

            setState(() {
              tasks.add(newTask);
            });
          }
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
