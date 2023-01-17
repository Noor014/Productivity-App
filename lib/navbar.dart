
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/screens/HomePage.dart';
import 'package:productivity_app/screens/Pomodoro.dart';
import 'package:productivity_app/screens/Profile.dart';
import 'package:productivity_app/screens/Progress.dart';
import 'package:productivity_app/screens/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  var uname='User';

  void initState() {
    // TODO: implement initState
    super.initState();
    loadCounter();
  }
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uname = prefs.getString('userName') ?? 'ok';
    });
  }



  @override
  final fs = FirebaseFirestore.instance;
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[850],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
                'assets/nav.jpeg',
              fit: BoxFit.fill,
            ),
          ),
          ListTile(
              leading: Icon(Icons.home,color: Colors.white,),
              title: Text('Home',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                      return HomePage();
                    }));
              }),
          ListTile(
              leading: Icon(Icons.bar_chart,color: Colors.white,),
              title: Text('Progress',style: TextStyle(color: Colors.white),),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.pushReplacement(context,
                     MaterialPageRoute(builder: (_) {
                       return Stats();
                     }));
               }),
          ListTile(
              leading: Icon(Icons.timer,color: Colors.white,),
              title: Text('Pomodoro',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                      return Pomodoro();
                    }));
              }),
          ListTile(
              leading: Icon(Icons.person_pin,color: Colors.white,),
              title: Text('Profile',style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) {
                      return ProfilePage();
                    }));
              }),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.white,),
            title: Text('Logout',style: TextStyle(color: Colors.white),),
            onTap: () async{
              SharedPreferences pref =await SharedPreferences.getInstance();
              fs.collection(uname).doc('tasknum').set({
                'monday': pref.getInt('mon'),
                'tuesday': pref.getInt('tues'),
                'wednesday': pref.getInt('wed'),
                'thursday': pref.getInt('thurs'),
                'friday': pref.getInt('fri'),
                'saturday': pref.getInt('sat'),
                'sunday': pref.getInt('sun'),
              });
              pref.remove('userName');
              pref.remove('mon');
              pref.remove('tues');
              pref.remove('wed');
              pref.remove('thurs');
              pref.remove('fri');
              pref.remove('sat');
              pref.remove('sun');
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_){
                return SignInPage();
              }));
            },
          ),
        ],
      ),
    );
  }
}
