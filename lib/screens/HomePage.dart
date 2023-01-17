import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/navbar.dart';
import 'package:productivity_app/screens/add_new_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool value = false;
  final fs = FirebaseFirestore.instance;
  var uname = 'User';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _mon =0;
  var _tues=0;
  var _wed=0;
  var _thurs=0;
  var _fri=0;
  var _sat=0;
  var _sun=0;

  @override
  void initState() {
    super.initState();
    loadCounter();
    loadDays();
  }

  void loadDays() async {
    var _mon = _prefs.then((SharedPreferences prefs){
      return (prefs.getInt('mon') ?? 0);
    });
    var _tues = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('tues') ?? 0);
    });
    var _wed = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('wed') ?? 0);
    });
    var _thurs = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('thurs') ?? 0);
    });
    var _fri = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('fri') ?? 0);
    });
    var _sat = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('sat') ?? 0);
    });
    var _sun = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('sun') ?? 0);
    });
  }

  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uname = prefs.getString('userName') ?? 'User';
    });
  }

  void _incrementMon() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int mon = (prefs.getInt('mon') ?? 0) + 1;
    setState(() {
      _mon = prefs.setInt("mon", mon).then((bool success) {
        return mon;
      }) as int;
    });
  }

  void _incrementTues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int tues = (prefs.getInt('tues') ?? 0) + 1;
    print('hello');
    setState(() {
      _tues = prefs.setInt("tues", tues).then((bool success) {
        return tues;
      }) as int ;
    });
  }

  void _incrementWed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int wed = (prefs.getInt('wed') ?? 0) + 1;
    setState(() {
      _wed = prefs.setInt("wed", wed).then((bool success) {
        return wed;
      }) as int;
    });
  }

  void _incrementThurs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int thurs = (prefs.getInt('thurs') ?? 0) + 1;
    setState(() {
      _thurs = prefs.setInt("thurs", thurs).then((bool success) {
        return thurs;
      }) as int;
    });
  }

  void _incrementFri() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int fri = (prefs.getInt('fri') ?? 0) + 1;
    setState(() {
      _fri = prefs.setInt("fri", fri).then((bool success) {
        return fri;
      }) as int;
    });
  }

  void _incrementSat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int sat = (prefs.getInt('sat') ?? 0) + 1;
    setState(() {
      _sat = prefs.setInt("sat", sat).then((bool success) {
        return sat;
      }) as int;
    });
  }

  Future<void> _incrementSun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int sun = (prefs.getInt('sun') ?? 0) + 1;
    setState(() {
      _sun = prefs.setInt("sun", sun).then((bool success) {
        return sun;
      }) as int;
    });
  }


  messages({required String uname}) {

    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection(uname)
        .orderBy('time')
        .snapshots();
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("something is wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            //child: CircularProgressIndicator(color: Colors.white70,),
          );
        }

        return SingleChildScrollView(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            primary: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot qs = snapshot.data!.docs[index];
              Timestamp t = qs['time'];
              DateTime d = t.toDate();
              print(d.toString());
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      // delete option
                      SlidableAction(
                        onPressed: (context) async{
                          await FirebaseFirestore.instance.runTransaction(
                                  (Transaction myTransaction) async {
                                await myTransaction
                                    .delete(snapshot.data!.docs[index].reference);
                              });
                     },
                        backgroundColor: Colors.red.shade400,
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // checkbox
                        Checkbox(
                          value: this.value,
                          onChanged: (bool? value) async{

                            String day =
                            DateFormat('EEEE').format(DateTime.now());
                            if (day == 'Monday') {
                              _incrementMon();
                            }
                            if (day == 'Tuesday') {
                              _incrementTues();
                            }
                            if (day == 'Wednesday') {
                              _incrementWed();
                            }
                            if (day == 'Thursday') {
                              _incrementThurs();
                            }
                            if (day == 'Friday') {
                              _incrementFri();
                            }
                            if (day == 'Saturday') {
                              _incrementSat();
                            }
                            if (day == 'Sunday') {
                              _incrementSun();
                            }
                            await FirebaseFirestore.instance.runTransaction(
                                    (Transaction myTransaction) async {
                                  await myTransaction
                                      .delete(snapshot.data!.docs[index].reference);
                                });
                          }


                        ),

                        // habit name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                qs['category'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0, left: 3.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 350,
                                    child: Text(
                                      qs['title'],
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    d.hour.toString() + ":" + d.minute.toString(),
                                    style:
                                    const TextStyle(color: Colors.black, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              );

            },
          ),
        );
      },
    );
  }

  final List<Widget> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Productivity App'),
          backgroundColor: Color(0xFF4b39ba),
      ),
      backgroundColor: Color(0xFF988DDC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Welcome " + uname + '!',
                style: TextStyle(color: Color(0xFF4b39ba), fontSize: 20,
                fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.79,
              child: messages(
                uname: uname,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () async {
            String? newText = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewTaskScreen(uname: uname)));
          },
          backgroundColor: Color(0xFF4b39ba),
          child: const Icon(Icons.add),
        );
      }),
      //drawer: NavDrawer()
    );
  }
}