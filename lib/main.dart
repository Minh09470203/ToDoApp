import 'package:flutter/material.dart';

import 'Model/items.dart';
import 'ModelButton.dart';
import 'cardbodywidget.dart';

void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(scaffoldBackgroundColor: Colors.white70),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<DataItems> items = [];

  void _handleAddTask(String name) {
    final newItem = DataItems(id: DateTime.now().toString(), name: name);
    setState(() {
      items.add(newItem);
    });
  }

  void _handleDeleteTask(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set entire body background to white
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ToDoList',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0, // Remove default shadow
      ),
      body: Column(
        children: [
          // Shadow separator below AppBar
          Container(
            height: 16,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
          ),
          // Remove the inner white container, use only SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                children: items.map((item) => CardBody(item: item, onDelete: (id) => _handleDeleteTask(id),)).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            context: context,
            builder: (BuildContext content) {
              return ModelButton(addTask: _handleAddTask);
            },
          );
        },
        child: Icon(Icons.add, size: 30, color: Colors.lightBlueAccent),
        backgroundColor: Colors.white,
      ),
    );
  }
}
