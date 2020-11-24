import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/model/post.dart';
import 'package:bloc_test/model/todo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> with ChangeNotifier {
  final http.Client httpClient;
  final http.Client httpClientTodo;

  PostBloc({@required this.httpClient, @required this.httpClientTodo})
      : super(PostState());

  String majorOneName = '';

  addMajorOne(String majorOneNameTemp) {
    majorOneName = majorOneNameTemp;
    notifyListeners();
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostFetched) {
      // print(event.variable);
      yield await _mapPostFetchedToState(state);
    }
  }

  Future<PostState> _mapPostFetchedToState(PostState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == APIStatus.initial) {
        final posts = await _fetchPosts(0, 10, "0", 0);
        final todos = await _fetchTodos(0, 10);
        final count = countList;
        final id = todos[1].id;
        return state.copyWith(
          status: APIStatus.success,
          posts: posts,
          todos: todos,
          hasReachedMax: false,
          id: id,
          countList: count,
        );
      }
      final posts = await _fetchPosts(state.posts.length, 10, "0", 0.0);
      final todos = await _fetchTodos(state.todos.length, 10);
      final count = countList;
      final id = todos[1].id;
      return posts.isEmpty && todos.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: APIStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              todos: List.of(state.todos)..addAll(todos),
              hasReachedMax: false,
              id: id,
              countList: count,
            );
    } on Exception {
      return state.copyWith(status: APIStatus.failure);
    }
  }

  Future<List<Post>> _fetchPosts(
      int startIndex, int limit, String id, double price) async {
    print(id);
    print(price);
    var response = await http.get(
        "https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit");
    if (response.statusCode == 200) {
      List posts = json.decode(response.body);
      return posts.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception();
    }
  }

  Future<List<Todo>> _fetchTodos(int startIndex, int limit) async {
    final response = await http.get(
        "https://jsonplaceholder.typicode.com/todos?_start=$startIndex&_limit=$limit");
    if (response.statusCode == 200) {
      List todos = json.decode(response.body);
      return todos.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception();
    }
  }

  List<String> countList = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Tweleve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
    "Twenty",
  ];
}
