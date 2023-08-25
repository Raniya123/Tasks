import 'package:get/get.dart';
import 'package:tasks/db/db_helper.dart';
import 'package:tasks/models/task.dart';

class TaskController extends GetxController {
  void onRead() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;
  Future<int> addTask({Task? task}) async {
    return await DBhelper.insert(task);
  }

// Get all the data from table
  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBhelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(int id) {
    DBhelper.delete(id);
  }

  void updateTask(int id) {
    DBhelper.update(id);
  }
}
