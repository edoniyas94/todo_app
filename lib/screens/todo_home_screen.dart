import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import '../models/todo_item.dart';
import '../widgets/todo_tile.dart';
import '../widgets/add_task_sheet.dart';

class TodoHomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const TodoHomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  late ConfettiController _confettiController;

  final List<TodoItem> _tasks = [
    TodoItem(
      id: '1',
      title: 'Make Tutorial',
      category: 'Work',
      priority: Priority.high,
    ),
    TodoItem(
      id: '2',
      title: 'Do exercise',
      category: 'Fitness',
      priority: Priority.medium,
    ),
    TodoItem(
      id: '3',
      title: 'Workout',
      category: 'Fitness',
      priority: Priority.low,
    ),
  ];

  String _filter = 'All'; // 'All', 'Active', 'Completed'

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _toggleTask(String id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _confettiController.play();
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  void _addNewTask(String title, String category, Priority priority) {
    setState(() {
      _tasks.add(
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          category: category,
          priority: priority,
        ),
      );
    });
  }

  List<TodoItem> get _filteredTasks {
    if (_filter == 'Active') {
      return _tasks.where((t) => !t.isCompleted).toList();
    } else if (_filter == 'Completed') {
      return _tasks.where((t) => t.isCompleted).toList();
    }
    return _tasks;
  }

  int get _completedCount =>
      _tasks.where((t) => t.isCompleted).length;
  double get _progress =>
      _tasks.isEmpty ? 0 : _completedCount / _tasks.length;

  void _showAddTaskDialog() {
    showAddTaskSheet(context: context, onAdd: _addNewTask);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TO DO',
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          Text(
                            '${_tasks.length - _completedCount} remaining tasks',
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          widget.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.nightlight_round,
                        ),
                        onPressed: widget.onToggleTheme,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Progress Tracker Widget
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFEA00),
                          Color(0xFFFFA000),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Task Progress',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_completedCount of ${_tasks.length} tasks completed',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                value: _progress,
                                backgroundColor: Colors.black12,
                                color: Colors.black,
                                strokeWidth: 6,
                              ),
                            ),
                            Text(
                              '${(_progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Filter Chips
                  Row(
                    children: ['All', 'Active', 'Completed'].map((
                      filter,
                    ) {
                      final isSelected = _filter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: const Color(0xFFFFD600),
                          onSelected: (selected) {
                            if (selected)
                              setState(() => _filter = filter);
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Task List
                  Expanded(
                    child: _filteredTasks.isEmpty
                        ? const Center(child: Text('No tasks found!'))
                        : ListView.builder(
                            itemCount: _filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = _filteredTasks[index];
                              return TodoTile(
                                task: task,
                                onToggle: () => _toggleTask(task.id),
                                onDelete: () => _deleteTask(task.id),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Confetti Overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.amber,
                Colors.purple,
                Colors.blue,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 6,
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
