import 'package:bloc_test/bloc/post_bloc.dart';
import 'package:bloc_test/view/filter_page.dart';
import 'package:bloc_test/widget/bottom_loader.dart';
import 'package:bloc_test/widget/post_list_item.dart';
import 'package:bloc_test/widget/todo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _postScrollController = ScrollController();
  final _todoScrollController = ScrollController();
  PostBloc _postBloc;

  // List<String> countList = [
  //   "One",
  //   "Two",
  //   "Three",
  //   "Four",
  //   "Five",
  //   "Six",
  //   "Seven",
  //   "Eight",
  //   "Nine",
  //   "Ten",
  //   "Eleven",
  //   "Tweleve",
  //   "Thirteen",
  //   "Fourteen",
  //   "Fifteen",
  //   "Sixteen",
  //   "Seventeen",
  //   "Eighteen",
  //   "Nineteen",
  //   "Twenty"
  // ];

  List<String> selectedCountList = [];

  @override
  void initState() {
    super.initState();
    _postScrollController.addListener(_onScrollPost);
    _todoScrollController.addListener(_onScrollTodo);
    _postBloc = context.read<PostBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostBloc>(context, listen: false).addMajorOne("Karim");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Provider.of<PostBloc>(context).majorOneName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<PostBloc, PostState>(
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
              return RefreshIndicator(
                child: Column(
                  children: [
                    state.countList == null || state.countList == 0
                        ? Expanded(
                            child: Center(
                            child: Text("No Text Selected"),
                          ))
                        : Expanded(
                            child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(selectedCountList[index]),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(),
                                itemCount: selectedCountList.length),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: () async {
                            print(state.countList.first);
                            // _postBloc.add(PostFetched(variable: 100));
                            var list = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilterPage(
                                  allTextList: state.countList,
                                ),
                              ),
                            );
                            if (list != null) {
                              setState(() {
                                selectedCountList = List.from(list);
                              });
                            }
                          },
                          child: Text("Filter Page"),
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Text("Filter Dialog"),
                        ),
                      ],
                    ),
                    state.todos[1].id == state.todos[0].id
                        ? Expanded(
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
                          )
                        : Center(
                            child: Text("${state.id}"),
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
                ),
                onRefresh: () async {
                  state.posts = [];
                  state.todos = [];
                  state.countList = [];
                  BlocProvider.of<PostBloc>(context).add(PostFetched());
                },
              );
            // return Column(
            //   children: [
            //     state.todos[1].id == state.todos[0].id
            //         ? Expanded(
            //             child: ListView.builder(
            //               itemBuilder: (BuildContext context, int index) {
            //                 return index >= state.posts.length
            //                     ? BottomLoader()
            //                     : PostListItem(post: state.posts[index]);
            //               },
            //               itemCount: state.hasReachedMax
            //                   ? state.posts.length
            //                   : state.posts.length + 1,
            //               controller: _postScrollController,
            //             ),
            //           )
            //         : Center(
            //             child: Text("${state.id}"),
            //           ),
            //     Expanded(
            //       child: ListView.builder(
            //         itemBuilder: (context, index) {
            //           return index >= state.todos.length
            //               ? BottomLoader()
            //               : TodoListItem(todo: state.todos[index]);
            //         },
            //         itemCount: state.hasReachedMax
            //             ? state.todos.length
            //             : state.todos.length + 1,
            //         controller: _todoScrollController,
            //       ),
            //     )
            //   ],
            // );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
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
