class TodoItem {
  int id;
  String title;
  String description;
  String type;
  bool completed;

  TodoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.completed = false,
  });
}