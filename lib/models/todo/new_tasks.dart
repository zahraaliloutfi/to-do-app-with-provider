import 'package:flutter/material.dart';
import 'package:untitled4/shared/components/components.dart';
import 'package:untitled4/shared/components/constants.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTask(task[index]),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              color: Colors.grey[300],
              height: 1.0,
            ),
        itemCount: task.length);
  }
}
