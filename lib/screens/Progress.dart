
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:productivity_app/helper/quote.dart';
import 'package:productivity_app/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Future<Quote>? quote;
  final fs = FirebaseFirestore.instance;
  var uname = 'User';
  late int _mon=0 ;
  late int _tues=0;
  late int _wed=0;
  late int _thurs=0;
  late int _fri=0;
  late int _sat=0;
  late int _sun=0;

  @override
  void initState() {
    super.initState();
    loadUname();
    loadCounter();
    quote = fetchQuote();
  }

  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mon = prefs.getInt('mon') ?? 0;
      _tues = prefs.getInt('tues') ?? 0;
      _wed = prefs.getInt('wed') ?? 0;
      _thurs = prefs.getInt('thurs') ?? 0;
      _fri = prefs.getInt('fri') ?? 0;
      _sat = prefs.getInt('sat') ?? 0;
      _sun = prefs.getInt('sun') ?? 0;
    });
    }

  void loadUname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uname = prefs.getString('userName') ?? 'ok';
    });
  }

  Future<Quote> fetchQuote() async{
    var url = Uri.parse("https://favqs.com/api/qotd");
    final http.Response response = await http.get(url);

    if(response.statusCode == 200){
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Quote');
    }
  }

  List findMin() {
    String min = 'Sunday';
    List list = [_mon, _tues, _wed, _thurs, _fri, _sat, _sun];
    int m = list[0];
    list.forEach((element) {
      if (element < m) {
        m = element;
      }
    });
    if (m == list[0]) {
      min = 'Monday';
    }
    if (m == list[1]) {
      min = 'Tuesday';
    }
    if (m == list[2]) {
      min = 'Wednesday';
    }
    if (m == list[3]) {
      min = 'Thursday';
    }
    if (m == list[4]) {
      min = 'Friday';
    }
    if (m == list[5]) {
      min = 'Saturday';
    }
    if (m == list[6]) {
      min = 'Sunday';
    }
      return [min, m];
  }

  List findMax() {
    String max = 'Monday';
    List list = [_mon, _tues, _wed, _thurs, _fri, _sat, _sun];
    int n = list[0];
    list.forEach((element) {
      if (element >n) {
        n = element;
      }
    });
    if (n == list[0]) {
      max = 'Monday';
    }
    if (n == list[1]) {
      max = 'Tuesday';
    }
    if (n == list[2]) {
      max = 'Wednesday';
    }
    if (n == list[3]) {
      max = 'Thursday';
    }
    if (n == list[4]) {
      max = 'Friday';
    }
    if (n == list[5]) {
      max = 'Saturday';
    }
    if (n == list[6]) {
      max = 'Sunday';
    }
      return [max, n];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Color(0xFF4b39ba),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF988DDC),
        child: SingleChildScrollView(
          child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/cover.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepPurple[100]
              ),
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width*0.7,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: FutureBuilder<Quote>(
                    future: quote,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                Text(snapshot.data!.quoteText, style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),),
                                Text('-'+snapshot.data!.quoteAuthor,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                )),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default, show a loading spinner.
                      //return CircularProgressIndicator();
                      return Text('Loading...');
                    },),
                ),
              ),
      ),
          ),
              SizedBox(height: 20,),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        width: MediaQuery.of(context).size.width*0.42,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Tasks completed',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Monday        : $_mon',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Tuesday       : $_tues',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Wednesday : $_wed',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Thursday     : $_thurs',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Friday           : $_fri',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Saturday       : $_sat',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Sunday         : $_sun',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(

                        height: MediaQuery.of(context).size.height*0.4,
                        width: MediaQuery.of(context).size.width*0.5,
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Wonderful on ${findMax()[0]} completed ${findMax()[1]} tasks ',
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Laziest on ${findMin()[0]} done ${findMin()[1]} tasks',
                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),

                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          ),
        ),
      ),
      drawer: const NavDrawer(),
    );
  }
}
