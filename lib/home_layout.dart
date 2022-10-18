import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled4/new_archived.dart';
import 'package:untitled4/new_done.dart';
import 'package:untitled4/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  int index = 0;
  List<Widget> tasks = [NewTasks(), NewDone(), NewArcived()];
  List<String> titles = ['Tasker', 'Done', 'Archived'];
  Database? database;
  IconData iconData = Icons.add;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isBottomsheet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: Text("${tasks[currentIndex]}"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // insertDatabase();
          if (isBottomsheet) {
            // if (formKey.currentState!.validate()) {   }//عشان لما اجي اقفله من غير ما اكتب حاجه فيه تقول empty
              insertDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text)
                  .then((value) {
                Navigator.pop(context);
                isBottomsheet = false;
                setState(() {
                  iconData = Icons.add;
                });
              });

          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                padding: EdgeInsetsDirectional.all(10),
                color: Colors.white,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Icon(Icons.title),
                          labelText: 'Task Title',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: timeController,
                        keyboardType: TextInputType.datetime,
                        onTap: () {
                          print('timming tapped');
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            timeController.text =
                                value!.format(context).toString();
                            print(value.format(context));
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Icon(Icons.watch_later),
                          labelText: ' Task Time',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'time empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        onTap: () {
                          print('date tapped');
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2023-01-01'))
                              .then((value) {
                            print(DateFormat.yMMMd().format(value!));
                            dateController.text =
                                DateFormat.yMMMd().format(value);
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefix: Icon(Icons.calendar_month),
                          labelText: ' Task date',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'date empty';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20,
            );
            isBottomsheet = true;
            setState(() {
              iconData = Icons.accessibility_new_outlined;
            });
          }
        },
        child: Icon(iconData),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archive'),
        ],
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      // onCreate:(database,version)async
      // {
      //   print('database created');
      //   await database.execute('CREATE TABLE ')
      // } ,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT ,statue TEXT) ')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error = ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    );
  }

  Future insertDatabase(
      {@required title, @required time, @required date}) async {
    return await database?.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,date, time ,statue) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted');
      }).catchError((error) {
        print('error${error.toString()}');
      });
      return Future.value();
    });
  }
}
