import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../db/database_service.dart';
import 'dart:async';

// State for loading state during CRUD
final tasksLoadingProvider = StateProvider<bool>((ref) => false);

// Search Query Provider
final searchProvider = StateProvider<String>((ref) => '');

// Filter Provider
final statusFilterProvider = StateProvider<TaskStatus?>((ref) => null);

// Main Task List Provider
class TaskNotifier extends StateNotifier<List<Task>> {
  final DatabaseService _db = DatabaseService();
  final Ref ref;

  TaskNotifier(this.ref) : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = await _db.getTasks();
  }

  Future<void> addTask(Task task) async {
    ref.read(tasksLoadingProvider.notifier).state = true;
    // Simulate 2s delay
    await Future.delayed(const Duration(seconds: 2));
    await _db.insertTask(task);
    await loadTasks();
    ref.read(tasksLoadingProvider.notifier).state = false;
  }

  Future<void> updateTask(Task task) async {
    ref.read(tasksLoadingProvider.notifier).state = true;
    // Simulate 2s delay
    await Future.delayed(const Duration(seconds: 2));
    await _db.updateTask(task);
    await loadTasks();
    ref.read(tasksLoadingProvider.notifier).state = false;
  }

  Future<void> deleteTask(String id) async {
    await _db.deleteTask(id);
    await loadTasks();
  }

  // Business logic: Is a task blocked?
  bool isTaskBlocked(Task task) {
    if (task.blockedByTaskId == null) return false;
    
    // Find blocker task. If it doesn't exist (e.g. was deleted), consider not blocked.
    final blockerIterator = state.where((t) => t.id == task.blockedByTaskId);
    if (blockerIterator.isEmpty) return false;
    
    final blocker = blockerIterator.first;
    // Blocked if blocker is NOT Done
    return blocker.status != TaskStatus.done;
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref);
});

// Filtered/Searched Task List
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final filterStatus = ref.watch(statusFilterProvider);

  return tasks.where((task) {
    final matchesSearch = task.title.toLowerCase().contains(searchQuery);
    final matchesFilter = filterStatus == null || task.status == filterStatus;
    return matchesSearch && matchesFilter;
  }).toList();
});
