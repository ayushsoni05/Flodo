import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../theme/app_theme.dart';
import 'task_form_screen.dart';

class MainListScreen extends ConsumerStatefulWidget {
  const MainListScreen({super.key});

  @override
  ConsumerState<MainListScreen> createState() => _MainListScreenState();
}

class _MainListScreenState extends ConsumerState<MainListScreen> {
  Timer? _debounce;
  final ScrollController _listScrollController = ScrollController();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchProvider.notifier).state = query;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);
    final currentFilter = ref.watch(statusFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.studioBackground,
      appBar: AppBar(
        title: Text(
          "Studio Tasks",
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: -0.8,
            color: AppTheme.studioText,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.tune_rounded, color: AppTheme.studioTextSecondary)
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        controller: _listScrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(tasks),
                  const SizedBox(height: 32),
                  _buildSearchField(),
                  const SizedBox(height: 24),
                  _buildFilterChips(currentFilter),
                ],
              ),
            ),
          ),
          if (filteredTasks.isEmpty)
             _buildEmptyState()
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = filteredTasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(
                        task: task,
                        onTap: () => _openTaskForm(context, task),
                        onDelete: () => _confirmDelete(context, task, ref),
                      ),
                    );
                  },
                  childCount: filteredTasks.length,
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
        ],
      ),
      floatingActionButton: _buildLargeActionButton(context),
    );
  }

  Widget _buildStatsRow(List<Task> tasks) {
    final completed = tasks.where((t) => t.status == TaskStatus.done).length;
    final total = tasks.length;
    final progress = total == 0 ? 0.0 : (completed / total) * 100;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Progress",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.studioTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "${progress.toInt()}%",
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.studioText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.auto_awesome_rounded, color: AppTheme.studioAccent, size: 20),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          width: 2,
          color: AppTheme.studioBorder,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Tasks",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.studioTextSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                total.toString().padLeft(2, '0'),
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.studioText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.studioSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.studioBorder),
      ),
      child: TextField(
        onChanged: _onSearchChanged,
        style: GoogleFonts.inter(color: AppTheme.studioText),
        decoration: InputDecoration(
          hintText: "Search tasks...",
          hintStyle: GoogleFonts.inter(color: AppTheme.studioTextSecondary),
          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.studioTextSecondary),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterChips(TaskStatus? currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip(null, "All", currentFilter == null),
          _buildChip(TaskStatus.todo, "Priority", currentFilter == TaskStatus.todo),
          _buildChip(TaskStatus.inProgress, "Active", currentFilter == TaskStatus.inProgress),
          _buildChip(TaskStatus.done, "Completed", currentFilter == TaskStatus.done),
        ],
      ),
    );
  }

  Widget _buildChip(TaskStatus? status, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (v) {
          if (v) ref.read(statusFilterProvider.notifier).state = status;
        },
        backgroundColor: AppTheme.studioSurface,
        selectedColor: AppTheme.studioAccent,
        labelStyle: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          color: isSelected ? Colors.white : AppTheme.studioTextSecondary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppTheme.studioAccent : AppTheme.studioBorder,
            width: 1,
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: AppTheme.studioBorder),
            const SizedBox(height: 16),
            Text(
              "Clear Studio",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.studioBorder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openTaskForm(context, null),
      backgroundColor: AppTheme.studioText,
      foregroundColor: Colors.white,
      label: Text(
        "New Task",
        style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 16),
      ),
      icon: const Icon(Icons.add_rounded),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _confirmDelete(BuildContext context, Task task, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task?"),
        content: Text("Are you sure you want to remove '${task.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("DELETE"),
          ),
        ],
      ),
    );
  }

  void _openTaskForm(BuildContext context, Task? task) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    );
  }
}
