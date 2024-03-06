import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          'TO DO APP ',
          style: TextStyle(fontSize: 30),
        ),
        iconTheme: IconThemeData(size: 40, color: Colors.white),
        centerTitle: true,
      ),
      drawer: Drawer(),
      body: Container(),
    );
  }
}
