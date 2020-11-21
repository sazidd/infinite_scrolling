import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/post.dart';
import 'model/todo.dart';

abstract class MainRepository {
  Future<List<dynamic>> getData(int startIndex, int limit);
}

class TodoRepository implements MainRepository {
  @override
  Future<List<Todo>> getData(int startIndex, int limit) async {
    final response = await http.get(
        "https://jsonplaceholder.typicode.com/todos?_start=$startIndex&_limit=$limit");
    if (response.statusCode == 200) {
      List todos = json.decode(response.body);
      return todos.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception();
    }
  }
}

class PostRepository implements MainRepository {
  @override
  Future<List<Post>> getData(int startIndex, int limit) async {
    var response = await http.get(
        "https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit");
    if (response.statusCode == 200) {
      List posts = json.decode(response.body);
      return posts.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception();
    }
  }
}

class NetworkException implements Exception {}
