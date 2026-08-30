import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestorecrud/model/todo.dart';
import 'package:firestorecrud/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeSccreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeSccreen> createState() => _HomeSccreenState();
}

class _HomeSccreenState extends State<HomeSccreen> {
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUi(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _displayTextInputDialog();
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text("Todo", style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildUi() {
    return SafeArea(child: Column(children: [_messagesListView()]));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          List todos = snapshot.data?.docs ?? [];

          if (todos.isEmpty) {
            return Center(child: Text('Add A todo'));
          }
          print(todos);
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              //without .data() can't access data
              //when working with firestore data it's needed
              //provided by firestore
              Todo todo = todos[index].data();
              //getting firestore auto id created
              String todoId = todos[index].id;
              print(todoId);
              print(todo.task);
              return Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.task),
                  subtitle: Text(
                    DateFormat("dd-MM-yyyy h:mm a")
                        .format(todo.updatedOn.toDate()),
                  ),
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      Todo updatedTodo = todo.copyWith(
                        isDone: !todo.isDone,
                        updatedOn: Timestamp.now(),
                      );
                      _databaseService.updateTodo(todoId, updatedTodo);
                    },
                  ),
                  onLongPress: () {
                    _databaseService.deleteTodo(todoId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add a Todo '),
        content: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(hintText: 'add task'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Todo todo = Todo(
                task: _textEditingController.text,
                isDone: false,
                createdOn: Timestamp.now(),
                updatedOn: Timestamp.now(),
              );
              _databaseService.addTodo(todo);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
