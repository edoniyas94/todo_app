import 'package:flutter/material.dart';

import '../models/todo_item.dart';

class TodoTile extends StatelessWidget {
  final TodoItem task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.redAccent;
      case Priority.medium:
        return Colors.orangeAccent;
      case Priority.low:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: task.isCompleted
              ? theme.cardColor.withOpacity(0.5)
              : const Color(0xFFFFF176),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? Colors.black
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: task.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: Colors.amber,
                    )
                  : null,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.black54,
            ),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
