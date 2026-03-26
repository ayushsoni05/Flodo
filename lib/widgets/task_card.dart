import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    required this.task,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final searchQuery = ref.watch(searchProvider).toLowerCase();

    final blocker = task.blockedByTaskId != null 
        ? tasks.where((t) => t.id == task.blockedByTaskId).firstOrNull 
        : null;
    final isBlocked = blocker != null && blocker.status != TaskStatus.done;
    const secondaryColor = AppTheme.studioTextSecondary;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isBlocked ? Colors.grey.withValues(alpha: 0.05) : AppTheme.studioBorder,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: isBlocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   _buildStatusIndicator(task.status, isBlocked),
                   const SizedBox(width: 8),
                   Text(
                     _getStatusLabel(task.status),
                     style: GoogleFonts.manrope(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       color: isBlocked ? Colors.grey : AppTheme.studioTextSecondary,
                       letterSpacing: 0.5,
                     ),
                   ),
                   const SizedBox(width: 12),
                   Expanded(
                    child: _buildTitle(task.title, searchQuery, isBlocked),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.grey),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: secondaryColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildMetaLabel(
                    icon: Icons.calendar_today_rounded, 
                    label: DateFormat('MMM d, y').format(task.dueDate),
                    color: secondaryColor,
                  ),
                  const Spacer(),
                  if (isBlocked) 
                     _buildMetaLabel(
                       icon: Icons.lock_outline_rounded, 
                       label: "STALLED",
                       color: Colors.red.shade400,
                     ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title, String query, bool isBlocked) {
    final baseStyle = GoogleFonts.manrope(
      fontSize: 18, 
      fontWeight: FontWeight.w700, 
      color: isBlocked ? Colors.grey : AppTheme.studioText,
      letterSpacing: -0.4,
    );

    if (query.isEmpty || !title.toLowerCase().contains(query)) {
      return Text(title, style: baseStyle);
    }

    final children = <TextSpan>[];
    final lowerTitle = title.toLowerCase();
    int start = 0;
    int index;

    while ((index = lowerTitle.indexOf(query, start)) != -1) {
      if (index > start) {
        children.add(TextSpan(text: title.substring(start, index)));
      }
      children.add(TextSpan(
        text: title.substring(index, index + query.length),
        style: const TextStyle(
          backgroundColor: Color(0xFFE0F2FE),
          color: Color(0xFF0284C7),
          fontWeight: FontWeight.w800,
        ),
      ));
      start = index + query.length;
    }

    if (start < title.length) {
      children.add(TextSpan(text: title.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: children,
      ),
    );
  }

  Widget _buildStatusIndicator(TaskStatus status, bool isBlocked) {
    final color = isBlocked ? Colors.grey : _getStatusColor(status);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildMetaLabel({required IconData icon, required String label, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return AppTheme.todoColor;
      case TaskStatus.inProgress: return AppTheme.doingColor;
      case TaskStatus.done: return AppTheme.doneColor;
    }
  }

  String _getStatusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo: return "To-Do";
      case TaskStatus.inProgress: return "In Progress";
      case TaskStatus.done: return "Done";
    }
  }
}
