import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:productivity_app/ForgotPassword.dart';
import 'package:productivity_app/screens/HomePage.dart';
import 'package:productivity_app/screens/SignUp.dart';
import 'package:productivity_app/screens/onboarding.dart';

import 'package:shared_preferences/shared_preferences.dart';


class SignInPage extends StatefulWidget {

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  bool showHome = false;
  void initState() {
    super.initState();
    loadCounter();
  }
  void loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    showHome = prefs.getBool('showHome')?? false;
  }
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFF988DDC),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
                children: [
                   Padding(
                    padding: EdgeInsets.all(10),
                       child: Container(
                     height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                             image: AssetImage("assets/signUp.jpg")
                         )
                      ),
                    ),
                   ),
                  Text('Welcome',
                    textScaleFactor: 2,
                    style: TextStyle(
                      color: Color(0xFF4b39ba),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  //Sign In Fields

                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 30, 5, 5),
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
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _emailController,

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.lock_sharp),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      controller: _passController,

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                          },
                          child: Text('Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight:FontWeight.bold,
                            ),),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed:()async{
                          try {
                            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passController.text,
                            );
                            SharedPreferences pref = await SharedPreferences
                                .getInstance();
                            pref.setString('userName', _emailController.text.replaceAll("@gmail.com", ""));
                            if(showHome)
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                            if(!showHome)
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OnboardingPage()));

                          } on FirebaseAuthException catch (e) {
                            String error = "";
                            if (e.code == 'user-not-found') {
                              error += "No user found for that email.";
                            } else if (e.code == 'wrong-password') {
                              error += "Wrong password provided for that user.";
                            }
                            else if(e.code=='invalid-email'){
                              error += "Invalid email";
                            }

                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: Text(error),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("Ok", style: TextStyle(color: Colors.black ),),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        } ,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 50),
                          backgroundColor: Color(0xFF4b39ba),
                          elevation: 10,  // Elevation
                          shadowColor: Colors.grey[300], //
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text("Sign In",
                          style: TextStyle(fontSize: 20,
                         color: Colors.white ),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RichText(
                        text: TextSpan(
                            text: "Do not have an account?",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20
                            ),
                            children: [
                              TextSpan(
                                  text: " Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap=() {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
                                  }
                              )
                            ]
                        )),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      side: BorderSide(color: Colors.white, width: 3, ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async{
                      final googleAccount = await GoogleSignIn().signIn();
                      if(googleAccount!=null){
                        final googleAuth = await googleAccount.authentication;
                        if(googleAuth.accessToken!=null && googleAuth.idToken!=null){
                          try{
                            String? name = googleAccount.displayName;
                            String? imageUrl = googleAccount.photoUrl;
                            String email = googleAccount.email;

                            await FirebaseAuth.instance.signInWithCredential(
                              GoogleAuthProvider.credential(
                                accessToken: googleAuth.accessToken,
                                idToken: googleAuth.idToken,
                              ),
                            );
                          } on FirebaseException catch(error){
                            print(error.message);
                          } catch(error){
                            //handle error
                          }
                        }
                        else{

                        }
                      }
                    },

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Image(
                            image: AssetImage("google_logo.jpeg"),
                            height: 25.0,
                           ),

                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ]
            ),
          ),

        ),
      ),
    );
  }
}
