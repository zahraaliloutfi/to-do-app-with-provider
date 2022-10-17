import 'package:flutter/material.dart';
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
  List<Widget> tasks = [NewTasks(), NewArcived(), NewDone()];
  List<String> titles = ['tasks', 'done', 'archived'];
  Database? database;
  IconData iconData =Icons.add;
  var scaffoldKey = GlobalKey<ScaffoldState>();
bool isBottomsheet =false;
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
          if(isBottomsheet){
            Navigator.pop(context);
            isBottomsheet =false;
            setState(() {
              iconData =Icons.add;
            });
          }else{scaffoldKey.currentState?.showBottomSheet((context) => Container(
            color: Colors.red,
            width: double.infinity,
            height: 200,
          ));
          isBottomsheet =true;
          setState(() {
            iconData =Icons.accessibility_new_outlined;
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

  void insertDatabase() {
    database?.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks (title ,date, time ,statue) VALUES("first","444","234","new")')
          .then((value) {
        print('$value inserted');
      }).catchError((error) {
        print('error${error.toString()}');
      });
      return Future.value();
    });
  }
}
