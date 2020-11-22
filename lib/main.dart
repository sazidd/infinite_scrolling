import 'package:bloc/bloc.dart';
import 'package:bloc_test/simple_bloc.dart';
import 'package:bloc_test/view/post_list.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'bloc/post_bloc.dart';

// void main() {
//   EquatableConfig.stringify = kDebugMode;
//   Bloc.observer = SimpleBlocObserver();
//   runApp(App());
// }

// class App extends MaterialApp {
//   App() : super(home: PostsPage());
// }

// class PostsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Posts')),
//       body: ChangeNotifierProvider(
//         create: (_) =>
//             PostBloc(httpClient: http.Client(), httpClientTodo: http.Client())
//               ..add(PostFetched()),
//         child: PostsList(),
//       ),
//     );
//   }
// }

void main() {
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) =>
          PostBloc(httpClient: http.Client(), httpClientTodo: http.Client())
            ..add(PostFetched()),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostsList(),
    );
  }
}
