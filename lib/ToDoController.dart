
import 'package:flutter/foundation.dart';
import 'package:to_do_app/todo.dart';


abstract class NetworkClient {
  void get(int a);
  void post();
}


class DioNetworkClient implements NetworkClient {
  @override
  void get(int a) {
    // TODO: implement get
  }

  @override
  void post() {
    // TODO: implement post
  }

}

class HttpNetworkClient implements NetworkClient {
  @override
  void get(int a) {
    // TODO: implement get
  }

  @override
  void post() {
    // TODO: implement post
  }

}

class ToDoController {

  final ValueNotifier<int> _sz = ValueNotifier(1);
  ValueListenable<int> get sz  => _sz;

  final ValueNotifier<List<ToDo>> todosList = ValueNotifier([]);

  // final todosList = [
  //   ToDo(id: "1", todoText: "Morning walk", isDone: true),
    // ToDo(id: "2", todoText: "Breakfast", isDone: true),
    // ToDo(id: "3", todoText: "Check mail"),
    // ToDo(id: "4", todoText: "Team working"),
    // ToDo(id: "5", todoText: "Work on mobile app"),
    // ToDo(id: "6", todoText: "Lunch with SBU Head."),
  // ];


  ToDoController() {
    todosList.value.add(ToDo(id: "1", todoText: "Morning walk", isDone: true));
  }

  addItem(ToDo newItem) {
    _sz.value++;
    todosList.value = List.from(todosList.value)..add(newItem);
  }

  deleteItem(String id) {
    _sz.value--;
    todosList.value = List.from(todosList.value)..removeWhere((element) => element.id == id);
  }

  updateItem(ToDo item) {
    item.isDone = !item.isDone;
    todosList.value = List.from(todosList.value);
  }
}
