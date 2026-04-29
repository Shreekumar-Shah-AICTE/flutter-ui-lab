import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:design_system/design_system.dart';

class _Task {
  String title;
  bool done;
  _Task({required this.title, this.done = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<_Task> _tasks = [
    _Task(title: 'Design the login screen'),
    _Task(title: 'Build API integration'),
    _Task(title: 'Write unit tests', done: true),
    _Task(title: 'Review pull request'),
  ];
  final _controller = TextEditingController();

  List<_Task> get _pending => _tasks.where((t) => !t.done).toList();
  List<_Task> get _completed => _tasks.where((t) => t.done).toList();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _tasks.insert(0, _Task(title: _controller.text.trim()));
      _controller.clear();
    });
    Navigator.pop(context);
  }

  void _toggleTask(_Task task) {
    HapticFeedback.mediumImpact();
    setState(() => task.done = !task.done);
  }

  void _deleteTask(_Task task) {
    HapticFeedback.heavyImpact();
    setState(() => _tasks.remove(task));
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              Text('New Task', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                style: GoogleFonts.plusJakartaSans(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.onSurfaceDim),
                ),
                onSubmitted: (_) => _addTask(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _addTask, child: const Text('Add Task')),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('MOMENTUM', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.onSurfaceDim, letterSpacing: 6))
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 4),
              Text('Tasks', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface))
                  .animate().fadeIn(duration: 400.ms, delay: 50.ms),
              const SizedBox(height: 4),
              Text('${_pending.length} remaining · ${_completed.length} done', style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim))
                  .animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 20),
              Expanded(
                child: _tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.onSurfaceDim.withOpacity(0.3)),
                            const SizedBox(height: 16),
                            Text('Nothing here yet.', style: GoogleFonts.plusJakartaSans(fontSize: 16, color: AppColors.onSurfaceDim)),
                            Text("What's on your mind?", style: GoogleFonts.plusJakartaSans(fontSize: 14, color: AppColors.onSurfaceDim.withOpacity(0.5))),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          ..._pending.map((t) => _buildTaskTile(t)),
                          if (_completed.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(children: [
                                Expanded(child: Divider(color: AppColors.border)),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('COMPLETED', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.onSurfaceDim, letterSpacing: 2))),
                                Expanded(child: Divider(color: AppColors.border)),
                              ]),
                            ),
                            ..._completed.map((t) => _buildTaskTile(t)),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskTile(_Task task) {
    return Dismissible(
      key: ValueKey(task.hashCode),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteTask(task),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
        child: Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      child: GestureDetector(
        onTap: () => _toggleTask(task),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: task.done ? AppColors.surfaceAlt.withOpacity(0.6) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: task.done ? Colors.transparent : AppColors.border.withOpacity(0.5)),
            boxShadow: task.done ? [] : AppTokens.subtleShadow,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: task.done ? AppColors.success : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: task.done ? AppColors.success : AppColors.onSurfaceDim.withOpacity(0.3), width: 1.5),
                ),
                child: task.done ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: task.done ? AppColors.onSurfaceDim : AppColors.onSurface,
                    decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
                    decorationColor: AppColors.onSurfaceDim,
                  ),
                  child: Text(task.title),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
