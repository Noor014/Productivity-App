import 'package:flutter/material.dart';
import 'package:productivity_app/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF4b39ba),
      ),
      backgroundColor: Color(0xFF988DDC),
      drawer: NavDrawer(),
    );
  }
}
