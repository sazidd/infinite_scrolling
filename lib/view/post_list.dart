import 'package:bloc_test/bloc/post_bloc.dart';
import 'package:bloc_test/widget/bottom_loader.dart';
import 'package:bloc_test/widget/post_list_item.dart';
import 'package:bloc_test/widget/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _postScrollController = ScrollController();
  final _todoScrollController = ScrollController();
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _postScrollController.addListener(_onScrollPost);
    _todoScrollController.addListener(_onScrollTodo);
    _postBloc = context.read<PostBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (!state.hasReachedMax && _isBottomPost && _isBottomTodo) {
          _postBloc.add(PostFetched());
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case APIStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case APIStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.posts.length
                          ? BottomLoader()
                          : PostListItem(post: state.posts[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.posts.length
                        : state.posts.length + 1,
                    controller: _postScrollController,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return index >= state.todos.length
                          ? BottomLoader()
                          : TodoListItem(todo: state.todos[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.todos.length
                        : state.todos.length + 1,
                    controller: _todoScrollController,
                  ),
                )
              ],
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _postScrollController.dispose();
    _todoScrollController.dispose();
    super.dispose();
  }

  void _onScrollPost() {
    if (_isBottomPost) _postBloc.add(PostFetched());
  }

  void _onScrollTodo() {
    if (_isBottomTodo) _postBloc.add(PostFetched());
  }

  // bool get _isBottom {
  //   if (!_postScrollController.hasClients && !_todoScrollController.hasClients)
  //     return false;
  //   final maxScroll = _postScrollController.position.maxScrollExtent;
  //   final maxScrollTodo = _todoScrollController.position.maxScrollExtent;
  //   final currentScroll = _postScrollController.offset;
  //   return currentScroll >= (maxScroll * 0.9);
  //   final currentScrollTodo = _todoScrollController.offset;
  //   return currentScrollTodo >= (maxScrollTodo * 0.9);
  // }

  bool get _isBottomPost {
    if (!_postScrollController.hasClients) return false;
    final maxScroll = _postScrollController.position.maxScrollExtent;
    final currentScroll = _postScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  bool get _isBottomTodo {
    if (!_todoScrollController.hasClients) return false;
    final maxScroll = _todoScrollController.position.maxScrollExtent;
    final currentScroll = _todoScrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
