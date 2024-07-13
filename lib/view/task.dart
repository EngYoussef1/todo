import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shard/cubit/srates.dart';

import '../shard/constant.dart';
import '../shard/cubit/cubit.dart';

// ignore: camel_case_types
class taskPage extends StatelessWidget {
  const taskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, appStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).newTasks;
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No Tasks , please add new tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(tasks[index]['id'].toString()),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          // Swipe left to delete
                          AppCubit.get(context)
                              .deleteData(id: tasks[index]['id']);
                        } else if (direction == DismissDirection.startToEnd) {
                          // Swipe right to update
                          AppCubit.get(context).updateData(
                              id: tasks[index]['id'], status: 'archive');
                        }
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(
                            '${tasks[index]['title']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text('${tasks[index]['date']}'),
                          leading: IconButton(
                            onPressed: () async {
                              AppCubit.get(context).updateData(
                                  id: tasks[index]['id'], status: 'done');
                            },
                            icon: Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.blue,
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '${tasks[index]['time']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
