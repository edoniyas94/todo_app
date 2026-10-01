enum Priority { low, medium, high }

class TodoItem {
  String id;
  String title;
  String category;
  Priority priority;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    required this.category,
    this.priority = Priority.medium,
    this.isCompleted = false,
  });
}
