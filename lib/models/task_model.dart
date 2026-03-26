import 'package:uuid/uuid.dart';

enum TaskStatus { todo, inProgress, done }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final String? blockedByTaskId; // ID of another task

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = TaskStatus.todo,
    this.blockedByTaskId,
  }) : id = id ?? const Uuid().v4();

  // Helper to get string status for DB
  String get statusString => status.name;

  // Manual copyWith for Riverpod/State updates
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    String? blockedByTaskId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      blockedByTaskId: blockedByTaskId ?? this.blockedByTaskId,
    );
  }

  // To Map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'blockedByTaskId': blockedByTaskId,
    };
  }

  // From Map for DB
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
      blockedByTaskId: map['blockedByTaskId'],
    );
  }
}
