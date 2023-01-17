import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Future passwordReset() async{
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim());
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text('Password reset link is sent to the provided email'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.deepPurpleAccent[500],
                padding: const EdgeInsets.all(10),
                child: const Text("Ok", style: TextStyle(color: Colors.black ),),
              ),
            ),
          ],
        );
      });
    } on FirebaseAuthException catch(e) {
      print(e);
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          content: Text(e.message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.deepPurpleAccent[500],
                padding: const EdgeInsets.all(10),
                child: const Text("Ok", style: TextStyle(color: Colors.black ),),
              ),
            ),
          ],
        );
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("Enter Your Email", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.grey.shade300),),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              cursorColor: Colors.black,
              style: TextStyle(
                color: Colors.black,
              ),
              keyboardType: TextInputType.emailAddress ,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                filled: true,
                fillColor: Colors.grey[300],
                hintStyle: TextStyle(color: Colors.grey[600]),
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: _emailController,
            ),
          ),
          MaterialButton(
            onPressed: () {
              passwordReset();
            },
            child: Text("Reset Password"),
            color: Colors.deepPurple[300],
          )
        ],
      ),
    );
  }
}