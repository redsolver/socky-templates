import 'package:shared/model/task.dart';
import 'package:socky_server/socky_server.dart';
import 'package:getbykey/getbykey.dart';

@Socky()
class Root {
  List<Task> tasks = [
    Task(name: 'Do something'),
    Task(name: 'Another task'),
  ];

  List<Task> listTasks() => tasks;

  Task createTask(String name) {
    final task = Task(name: name);
    tasks.add(task);
    return task;
  }

  void setTaskState(String id, bool done) {
    final task = tasks.getByKey(id);
    task.done = done;
  }

  void deleteTask(String id) {
    final task = tasks.getByKey(id);
    if (!task.done)
      throw Exception('You can only delete tasks marked as "done"');
    tasks.remove(task);
  }
}
