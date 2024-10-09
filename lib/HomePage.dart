
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ToDoItems.dart';
import 'package:to_do_app/todo.dart';
import 'ToDoController.dart';
import 'package:avatar_glow/avatar_glow.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  late final ToDoController todoController;

  @override
  void initState() {
    todoController = ToDoController();  //instance created lately
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF7cded6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0ec3e3) ,
        title: const Text(
            "ToDo App(ValueNotifier)",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async{

                },
                child: const Text("Go"),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      onChanged: (value){
            
                      },
                      decoration: const InputDecoration(
            
                        contentPadding: EdgeInsets.all(0),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 21,
                        ),
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 20,
                          minWidth: 25
                        ),
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey),
            
                      ),
                    ),
                  ),
                ),
            
                Container(
                  margin: const EdgeInsets.only(
                    top: 15,
                    bottom: 10,
                  ),
                  child: ValueListenableBuilder(                     //1st stream builder
                    valueListenable: todoController.sz,
                    builder: (context, value, child) {
                      return InkWell(
                        child: Text(
                            "All ToDos: $value",
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                        ),
                      );
                    },
                  ),
                ),
            
                ValueListenableBuilder(                         //second stream builder
                  valueListenable: todoController.todosList,    // listen to your stream
                  // initialData: [ToDo(id: "1", todoText: "Morning walk", isDone: true),],
                  builder: (context, value, child) {

                    return Column(
                      children: value.map((e) => ToDoItems(
                        onToDoChanged: updateToDo,  //callback func send
                        onDelete: deleteToDo,
                        todo: e,
                      ),
                      ).toList(),

                    );
                  },
                ),
            
              ],
            ),
          ),

          ///bottom section for adding list
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 10,
                  ),
                  child: AvatarGlow(
                    endRadius: 30.0,
                    animate: true,
                    duration: const Duration(microseconds: 2000),
                    glowColor: Colors.blue,
                    repeat: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: const Icon(Icons.mic, size: 25, color: Colors.white),
                        onPressed: (){
                          textController.text = "Abed";
                        },
                      ),
                    ),
                  ),

                ),
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: "Add a new ToDo item",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      if (kDebugMode) {
                        print(textController.text);
                        print(DateTime.now().millisecondsSinceEpoch.toString());
                      }
                      todoController.addItem(ToDo(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          todoText: textController.text),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
                    child: const Text("+", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }

  //callback methods
  void updateToDo(ToDo item){
    todoController.updateItem(item);
  }
  void deleteToDo(String id){
    todoController.deleteItem(id);
  }
}
