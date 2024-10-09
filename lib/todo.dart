
class ToDo{
  String? id;
  String? todoText;
  bool isDone;

  ToDo({                  //Constructor
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

}