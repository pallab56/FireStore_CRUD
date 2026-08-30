import 'package:firestorecrud/services/database_service.dart';
import 'package:flutter/material.dart';

class HomeSccreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeSccreen> createState() => _HomeSccreenState();
}

class _HomeSccreenState extends State<HomeSccreen> {
  final DatabaseService _databaseService = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUi(),
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
          return ListView();
        },
      ),
    );
  }
}
