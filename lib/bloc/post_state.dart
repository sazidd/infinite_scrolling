part of 'post_bloc.dart';

enum APIStatus { initial, success, failure }

class PostState extends Equatable {
  PostState({
    this.status = APIStatus.initial,
    this.posts = const <Post>[],
    this.todos = const <Todo>[],
    this.hasReachedMax = false,
    this.id,
  });

  final APIStatus status;
  List<Post> posts;
  List<Todo> todos;
  final bool hasReachedMax;
  final int id;

  PostState copyWith({
    APIStatus status,
    List<Post> posts,
    List<Todo> todos,
    bool hasReachedMax,
    int id,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      id: id,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [status, posts, todos, hasReachedMax, id];
}
