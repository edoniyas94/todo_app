import 'package:flutter/material.dart';

import '../models/todo_item.dart';

void showAddTaskSheet({
  required BuildContext context,
  required void Function(
    String title,
    String category,
    Priority priority,
  )
  onAdd,
}) {
  final titleController = TextEditingController();
  final categoryController = TextEditingController(text: 'General');
  Priority selectedPriority = Priority.medium;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Task',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Priority: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<Priority>(
                      value: selectedPriority,
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedPriority = val);
                        }
                      },
                      items: Priority.values.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD600),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (titleController.text.trim().isNotEmpty) {
                        onAdd(
                          titleController.text.trim(),
                          categoryController.text.trim(),
                          selectedPriority,
                        );
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: const Text(
                      'Add Task',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
