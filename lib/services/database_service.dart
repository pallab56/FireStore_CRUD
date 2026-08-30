import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestorecrud/model/todo.dart';

/// firestore collection name "todos"
/// should be same as collection name
const String TODO_COLLECTION_REF = 'todos';

class DatabaseService {
  /// crete firestore instance
  final _firestore = FirebaseFirestore.instance;

  /// collection references
  ///
  late final CollectionReference _todoref;
  DatabaseService() {
    //creted reference toward firestore collection
    //that will convert collection to todo  and todo to json to pass to firestore

    _todoref = _firestore
        .collection(TODO_COLLECTION_REF)
        .withConverter<Todo>(
          fromFirestore: (snapshot, _) {
            return Todo.fromJson(snapshot.data()!);
          },
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  //fn to get todo from database

  Stream<QuerySnapshot> getTodos() {
    return _todoref.snapshots();
  }

  // fn to add data to firestore
  void addTodo(Todo todo) async {
    await _todoref.add(todo);
  }

  void updateTodo(String todoId, Todo todo) async {
    await _todoref.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    _todoref.doc(todoId).delete();
  }
}
