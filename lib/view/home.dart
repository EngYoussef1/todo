import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shard/cubit/cubit.dart';
import 'package:todo/shard/cubit/srates.dart';
import 'package:todo/sqflteDB.dart';
import 'package:todo/view/archive.dart';
import 'package:todo/view/done.dart';
import 'package:todo/view/task.dart';
import '../shard/constant.dart';
import '../shard/sharedwidget.dart';

class HomePage extends StatelessWidget {
  @override
  var scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (BuildContext context) => AppCubit()..createdatabase(),
      child: BlocConsumer<AppCubit, appStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.IsBottomSheetshow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertdatabase(titleController.text,
                            timeController.text, dateController.text)
                        .then((value) {
                      Navigator.pop(context);
                      cubit.IsBottomSheetshow = false;
                      print(cubit.tasks);
                    });
                  }
                  ;
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                difaulttextformfield(
                                  controller: titleController,
                                  labelText: 'Title',
                                  icon: Icons.title,
                                  onChangedfunction: (String) {},
                                  keyboardType: TextInputType.text,
                                  validation: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                difaulttextformfield(
                                  controller: timeController,
                                  labelText: 'Time',
                                  icon: Icons.punch_clock,
                                  onChangedfunction: (value) {},
                                  tapfunction: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    });
                                  },
                                  keyboardType: TextInputType.datetime,
                                  validation: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                difaulttextformfield(
                                  controller: dateController,
                                  labelText: 'Date',
                                  icon: Icons.date_range,
                                  onChangedfunction: (value) {},
                                  tapfunction: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030))
                                        .then((value) {
                                      dateController.text =
                                          value!.toString().substring(0, 10);
                                      print(value.toString().substring(0, 10));
                                    });
                                  },
                                  keyboardType: TextInputType.datetime,
                                  validation: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }

                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        icon: Icons.edit, isShow: false);
                  });
                  cubit.changeBottomSheetState(icon: Icons.add, isShow: true);
                }
              },
              backgroundColor: Colors.blue,
              child: Icon(cubit.icontype),
            ),
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: const TextStyle(fontSize: 30),
              ),
              iconTheme: const IconThemeData(size: 40, color: Colors.white),
              centerTitle: true,
            ),
            body: state is AppGetDatabaseLoadingState
                ? Center(child: CircularProgressIndicator())
                : cubit.pages[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task), label: 'tasks'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: 'done'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: 'archive'),
                ]),
          );
        },
      ),
    );
  }
}
