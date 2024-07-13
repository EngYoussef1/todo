import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shard/cubit/srates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/view/archive.dart';
import 'package:todo/view/done.dart';
import 'package:todo/view/task.dart';

class AppCubit extends Cubit<appStates> {
  AppCubit() : super(AppintialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List pages = [const taskPage(), const donePage(), const archivePage()];
  List<String> titles = ['New Task', 'Done Task', 'archive Task'];
  late Database database;
  List<Map> tasks = [];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  bool IsBottomSheetshow = false;
  IconData icontype = Icons.edit;

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createdatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)
            ''').then((value) {
          print("table created");
        }).catchError((error) {
          print("error creating table$error");
        });
      },
      onOpen: (database) {
        getfromdatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
      print("database open");
    });
  }

  insertdatabase(@required String title, @required String time,
      @required String date) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        print("$value inserted successfully");
        getfromdatabase(database);
      }).catchError((error) {
        print("error inserting data $error");
      });
      return null;
    });
  }

  getfromdatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery("SELECT * FROM tasks").then((value) {
      tasks = value;
      emit(AppGetDatabaseState());
      tasks.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archiveTasks.add(element);
      });
      print(tasks);
    });
  }

  updateData({
    required int id,
    required String status,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getfromdatabase(database);
      emit(AppUpdateDatabaseState());
      print(tasks);
    });
  }

  deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getfromdatabase(database);
      emit(AppDeleteDatabaseState());
      print(tasks);
    });
  }

  void changeBottomSheetState({
    required IconData icon,
    required bool isShow,
  }) {
    IsBottomSheetshow = isShow;
    icontype = icon;
    emit(AppChangeBottomSheetStateState());
  }
}
