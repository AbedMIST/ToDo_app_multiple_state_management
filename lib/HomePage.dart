import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/ToDoItems.dart';
import 'package:to_do_app/todo.dart';

import 'ToDoController.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  late final ToDoController todoController;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late AnimationController _animationController;
  late SpringSimulation _simulation;

  @override
  void initState() {
    todoController=ToDoController();  //instance created lately
    super.initState();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
      duration: const Duration(seconds: 2),
    );

    _simulation = SpringSimulation(
      const SpringDescription(
          mass: 0.5,
          stiffness: 100,
          damping: 10
      ),
      0,  //start position
      100, //end position
      0, //velocity
    );

    _animationController.animateWith(_simulation);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFF7cded6),
      appBar: AppBar(
        backgroundColor: Color(0xFF0ec3e3) ,
        title: Text("ToDo App(StreamBuilder)"),
        centerTitle: true,
        actions: [
          ElevatedButton(
              onPressed: () async{

                final connectivityResult = await (Connectivity().checkConnectivity());
                print(connectivityResult);

                if (connectivityResult == ConnectivityResult.mobile) {
                  print("I am connected to a mobile network.");
                } else if (connectivityResult == ConnectivityResult.wifi) {
                  print("I am connected to a wifi network.");
                } else if (connectivityResult == ConnectivityResult.ethernet) {
                  print("I am connected to a ethernet network.");
                } else if (connectivityResult == ConnectivityResult.vpn) {
                  print("I am connected to a vpn network.");
                } else if (connectivityResult == ConnectivityResult.bluetooth) {
                  print("I am connected to a bluetooth.");
                } else if (connectivityResult == ConnectivityResult.other) {
                  print("I am connected to a network which is not in the above mentioned networks.");
                } else if (connectivityResult == ConnectivityResult.none) {
                  print("I am not connected to any network.");
                }
              },
              child: Text("Go"),
          ),
        ],
      ),

      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(

              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    onChanged: (value){

                    },
                    decoration: InputDecoration(

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Connection Status: ${_connectionStatus}",style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 35,
                      bottom: 20,
                    ),
                    child: StreamBuilder(                     //1st stream builder
                      stream: todoController.stream,
                      builder: (context, snap) {
                        return Text(
                            "All ToDos: ${todoController.size()}",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                        );
                      }
                    ),
                  ),
                ),

                StreamBuilder(                         //second stream builder
                  stream: todoController.stream,    // listen to your stream
                  initialData: [ToDo(id: "1", todoText: "Morning walk", isDone: true),],
                  builder: (BuildContext context,snapshot) {

                    if (snapshot.hasData) {  // Stream has emitted data
                      var values = snapshot.data!;
                      // Build your UI based on the data
                      return Column(
                        children: values.map((e) => ToDoItems(
                            onToDoChanged: updateToDo,  //callback func send
                            onDelete: deleteToDo,
                            todo: e,
                          ),
                        ).toList(),

                      ); //Update UI

                    }
                    else if (snapshot.hasError) {  // Stream has encountered an error
                      return Text('Error: ${snapshot.error}');
                    }
                    else {      // Stream is still loading
                      return const SizedBox.shrink();
                    }
                  },
                ),

                InkWell(
                  onTap: (){
                    print("tapped");
                    _animationController.animateWith(_simulation);
                  },
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(150,_animationController.value),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            )
          ),

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
                    duration: Duration(microseconds: 2000),
                    glowColor: Colors.blue,
                    repeat: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.mic, size: 25, color: Colors.white),
                        onPressed: (){
                          textController.text = "Abed";
                          _animationController.animateWith(_simulation);
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
                        decoration: InputDecoration(
                          hintText: "Add a new ToDo item",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text("+", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                    onPressed: (){
                      print(textController.text);
                      print(DateTime.now().millisecondsSinceEpoch.toString());
                      todoController.addItem(ToDo(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          todoText: textController.text),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      elevation: 10,
                    ),
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      print(result);
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    //got a new connectivity status
    setState(() {
      _connectionStatus = result;
      print(_connectionStatus);
    });
  }
}
