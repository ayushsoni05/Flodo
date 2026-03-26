import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _keyTasks = 'tasks_data';

  Future<void> insertTask(Task task) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == task.id);
    tasks.add(task);
    await _saveTasks(tasks);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyTasks);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((j) => Task.fromMap(j as Map<String, dynamic>)).toList();
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    } else {
      tasks.add(task);
    }
    await _saveTasks(tasks);
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);
    await _saveTasks(tasks);
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => t.toMap()).toList();
    await prefs.setString(_keyTasks, jsonEncode(jsonList));
  }
}
