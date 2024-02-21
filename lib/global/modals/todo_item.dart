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
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'completed': completed ? 1 : 0,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'],
      completed: map['completed'] == 1,
    );
  }
}