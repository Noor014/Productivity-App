
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/screens/HomePage.dart';

class NewTaskScreen extends StatefulWidget {
  String uname;
  NewTaskScreen({required this.uname});

  @override
  State<StatefulWidget> createState() => _NewTaskScreen(uname: uname);
}

class _NewTaskScreen extends State<NewTaskScreen> {
  String uname;
  _NewTaskScreen({required this.uname});
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final fs = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF988DDC),
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: Color(0xFF4b39ba),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(255, 130, 4, 241),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: 'Task',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    icon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.event, color: Colors.white, size: 25),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  controller: _titleController,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(50),
                  color: Color.fromARGB(255, 130, 4, 241),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: 'Category',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    icon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.category_sharp, color: Colors.white, size: 25),
                    ),
                  ),
                  controller: _categoryController,
                ),
              ),
            ),

            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      fs.collection(uname).doc().set({
                        'title': _titleController.text.trim(),
                        'done': false,
                        'time': DateTime.now(),
                        'category': _categoryController.text.trim(),
                      });
                      _titleController.clear();
                      _categoryController.clear();
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) {
                          return HomePage();
                        }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                    child: Text("ADD"),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}