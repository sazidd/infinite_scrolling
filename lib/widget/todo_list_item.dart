import 'package:bloc_test/model/todo.dart';
import 'package:flutter/material.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({Key key, @required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Text(
        '${todo.id}',
        style: textTheme.caption,
      ),
      title: Text(
        todo.title,
        style: TextStyle(color: Colors.red),
      ),
      subtitle: Text(todo.title),
      isThreeLine: true,
      dense: true,
    );
  }
}
