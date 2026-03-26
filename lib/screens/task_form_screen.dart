import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/draft_provider.dart';
import '../theme/app_theme.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;
  const TaskFormScreen({this.task, super.key});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime _dueDate = DateTime.now();
  TaskStatus _status = TaskStatus.todo;
  String? _blockedByTaskId;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(draftProvider);
    _titleController = TextEditingController(
      text: widget.task?.title ?? draft.title,
    );
    _descController = TextEditingController(
      text: widget.task?.description ?? draft.description,
    );
    
    if (widget.task != null) {
      _dueDate = widget.task!.dueDate;
      _status = widget.task!.status;
      _blockedByTaskId = widget.task!.blockedByTaskId;
    }

    _titleController.addListener(() {
      if (widget.task == null) {
        ref.read(draftProvider.notifier).updateTitle(_titleController.text);
      }
    });
    _descController.addListener(() {
      if (widget.task == null) {
        ref.read(draftProvider.notifier).updateDescription(_descController.text);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(tasksLoadingProvider);
    final allTasks = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: AppTheme.studioBackground,
      appBar: AppBar(
        title: Text(
          widget.task == null ? "New Studio Task" : "Edit Task",
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppTheme.studioText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Details"),
                  _buildStudioField(
                    controller: _titleController,
                    label: "Task Title",
                    hint: "e.g., Design Review",
                    icon: Icons.edit_note_rounded,
                    enabled: !isLoading,
                    validator: (v) => v!.isEmpty ? "Title is required" : null,
                  ),
                  const SizedBox(height: 16),
                  _buildStudioField(
                    controller: _descController,
                    label: "Description",
                    hint: "Add more details...",
                    icon: Icons.notes_rounded,
                    enabled: !isLoading,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionLabel("Planning"),
                  _buildStudioDatePicker(enabled: !isLoading),
                  const SizedBox(height: 16),
                  _buildStudioStatusToggle(enabled: !isLoading),
                  const SizedBox(height: 16),
                  _buildStudioBlockerSelection(allTasks, enabled: !isLoading),
                ],
              ),
            ),
          ),
          _buildSubmitButton(isLoading),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppTheme.studioTextSecondary,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildStudioField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    int maxLines = 1,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.studioText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.studioTextSecondary, fontWeight: FontWeight.w600),
        hintText: hint,
        hintStyle: TextStyle(color: AppTheme.studioTextSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: AppTheme.studioTextSecondary),
        fillColor: AppTheme.studioSurface,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.studioBorder)),
      ),
    );
  }

  Widget _buildStudioDatePicker({bool enabled = true}) {
    return InkWell(
      onTap: enabled ? () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppTheme.studioAccent,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: AppTheme.studioText,
              ),
            ),
            child: child!,
          ),
        );
        if (date != null) setState(() => _dueDate = date);
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.studioSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.studioBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_rounded, color: AppTheme.studioTextSecondary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("DUE DATE", style: GoogleFonts.manrope(color: AppTheme.studioTextSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const SizedBox(height: 2),
                 Text(
                   DateFormat('MMMM d, y').format(_dueDate),
                   style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.studioText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioStatusToggle({bool enabled = true}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.studioSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.studioBorder),
      ),
      child: Row(
        children: TaskStatus.values.map((s) {
          final isSelected = _status == s;
           Color color;
          String label;
          switch(s) {
            case TaskStatus.todo: color = AppTheme.todoColor; label = "To-Do"; break;
            case TaskStatus.inProgress: color = AppTheme.doingColor; label = "In Progress"; break;
            case TaskStatus.done: color = AppTheme.doneColor; label = "Done"; break;
          }
          return Expanded(
            child: InkWell(
              onTap: enabled ? () => setState(() => _status = s) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                   color: isSelected ? color.withValues(alpha: 0.08) : Colors.transparent,
                   borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? color : Colors.grey.shade300)),
                    const SizedBox(height: 6),
                    Text(label, style: GoogleFonts.manrope(color: isSelected ? AppTheme.studioText : AppTheme.studioTextSecondary, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStudioBlockerSelection(List<Task> tasks, {bool enabled = true}) {
    final availableTasks = tasks.where((t) => t.id != widget.task?.id).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.studioSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.studioBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String?>(
          initialValue: _blockedByTaskId,
          decoration: const InputDecoration(labelText: "Depends on (Filter)", border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
          isExpanded: true,
          onChanged: enabled ? (v) => setState(() => _blockedByTaskId = v) : null,
          items: [
            const DropdownMenuItem(value: null, child: Text("Independent")),
            ...availableTasks.map((t) => DropdownMenuItem(
               value: t.id,
               child: Text(t.title, overflow: TextOverflow.ellipsis),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Positioned(
      bottom: 32,
      left: 20,
      right: 20,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.studioText,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _saveTask,
                child: Text(
                  widget.task == null ? "Save Task" : "Update Task",
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final task = (widget.task ?? Task(
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate,
    )).copyWith(
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate,
      status: _status,
      blockedByTaskId: _blockedByTaskId,
    );

    if (widget.task == null) {
      await ref.read(taskProvider.notifier).addTask(task);
      ref.read(draftProvider.notifier).clearDraft();
    } else {
      await ref.read(taskProvider.notifier).updateTask(task);
    }

    if (mounted) Navigator.pop(context);
  }
}
