import 'package:bloc_test/bloc/post_bloc.dart';
import 'package:bloc_test/view/post_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocProvider(
        create: (_) =>
            PostBloc(httpClient: http.Client(), httpClientTodo: http.Client())
              ..add(PostFetched()),
        child: PostsList(),
      ),
    );
  }
}
