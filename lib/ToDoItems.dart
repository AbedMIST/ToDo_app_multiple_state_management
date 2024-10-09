
import 'package:flutter/material.dart';
import 'package:to_do_app/todo.dart';


class ToDoItems extends StatelessWidget {

  //final ToDoController todoController;   //pas the ref controller here.
  final onToDoChanged;        //func receive
  final onDelete;
  final ToDo todo;


  const ToDoItems({
    super.key,
    required this.onToDoChanged,
    required this.onDelete,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: ListTile(
        onTap: (){
          print(todo.id);
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.green,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(7),
          ),
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.delete),
            iconSize: 18,
            onPressed: (){
              print("Deleted id => ${todo.id}");
              onDelete(todo.id.toString());
            },
          ),
        ),

      ),
    );
  }
}
