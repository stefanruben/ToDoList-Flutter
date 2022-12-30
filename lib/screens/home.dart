import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../item.dart';
import '../models/todo.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _myBox = Hive.box('mybox');
  final list = ToDo.todoList();
  final _todoController = TextEditingController();
  List<ToDo> _foundToDo = [];

  @override
  void initState() {
    // TODO: implement initState
    _foundToDo = list;
    // if (_myBox.get("TODOLIST") == null) {
    //   list.createInitialData();
    // } else {
    //   // there already exists data
    //   list.loadData();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: _buildApp(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 15),
                        child: const Text(
                          'To Do List',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      for (ToDo todoo in _foundToDo)
                        itemDart(todo: todoo,
                        onToDoChanged: _handleToDoChange,
                        onDeletedItem: _deleteToDoItem,
                        updateToDo: _updateTodo)
                    ],
                  )
                )
              ],
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(
                          5.0,
                          5.0,
                        ),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
                      hintText: 'Add New ToDo',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                  _addItem(_todoController.text);
                  },
                  child: const Text('+', style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade400, elevation: 20, minimumSize: Size(50, 50)
                  ),
                ),
              )
            ],),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo toDo){
    setState(() {
      //list.isDone = !list.isDone;
      toDo.isDone = !toDo.isDone;
    });
    //list.updateDataBase();
  }

  void _deleteToDoItem(String id) {
    setState(() {
      list.removeWhere((item) => item.id == id);
    });
    //list.updateDataBase();
  }

  void _addItem(String toDo){
    setState(() {
      list.add(ToDo(id: DateTime.now().millisecondsSinceEpoch.toString(), nameTodo: toDo));
      //print(list.toDoList);
    });
    _todoController.clear();
  }

  void search(String search){
    List<ToDo> results = [];
    if (search.isEmpty) {
      results = list;
    } else {
      results = list
          .where((item) => item.nameTodo!
          .toLowerCase()
          .contains(search.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  void _updateTodo(ToDo toDo, String name){
    setState(() {
      //list.nameTodo = name;
      toDo.nameTodo = name;
    });
  }

  Container searchBox() {
    return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              onChanged: (value) => search(value),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 25, ),
                prefixIconConstraints: BoxConstraints(maxHeight: 25, minWidth: 25),
                hintText: 'Search',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
          );
  }

  AppBar _buildApp() {
    return AppBar(
      elevation: 0,
      title: Container(
        child: Text('To Do List App'),
      ),
    );
  }
}