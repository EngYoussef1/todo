import 'package:flutter/material.dart';
import 'package:todo/view/archive.dart';
import 'package:todo/view/done.dart';
import 'package:todo/view/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int curentIndex = 0;
  List pages = [taskPage(), donePage(), archivePage()];
  List<String> titles = ['New Task', 'Done Task', 'archive Task'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue, //<-- SEE HERE
      ),
      appBar: AppBar(
        title: Text(
          titles[curentIndex],
          style: TextStyle(fontSize: 30),
        ),
        iconTheme: IconThemeData(size: 40, color: Colors.white),
        centerTitle: true,
      ),
      drawer: Drawer(),
      body: pages[curentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: curentIndex,
          onTap: (value) {
            setState(() {
              curentIndex = value;
              print(curentIndex);
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'done'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive), label: 'archive'),
          ]),
    );
  }
}
