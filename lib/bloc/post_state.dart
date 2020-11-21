part of 'post_bloc.dart';

enum APIStatus { initial, success, failure }

class PostState extends Equatable {
  const PostState({
    this.status = APIStatus.initial,
    this.posts = const <Post>[],
    this.todos = const <Todo>[],
    this.hasReachedMax = false,
  });

  final APIStatus status;
  final List<Post> posts;
  final List<Todo> todos;
  final bool hasReachedMax;

  PostState copyWith({
    APIStatus status,
    List<Post> posts,
    List<Todo> todos,
    bool hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      todos: todos ?? this.todos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [status, posts, todos, hasReachedMax];
}
