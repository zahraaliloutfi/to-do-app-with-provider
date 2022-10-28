import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled4/models/todo/new_archived.dart';
import 'package:untitled4/models/todo/new_done.dart';
import 'package:untitled4/models/todo/new_tasks.dart';
import 'package:untitled4/shared/components/constants.dart';
import 'package:untitled4/shared/cubit/cubit.dart';
import 'package:untitled4/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  Database? database;
  IconData iconData = Icons.add;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  bool isBottomsheet = false;

  HomeLayout({super.key});

  // @override
  // void initState() {
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //create object from appcubit
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: ( context, state) {},
        builder: ( context,  state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: task.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : cubit.tasks[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // insertDatabase();
                if (isBottomsheet) {
                  if (formKey.currentState!.validate()) {
                    //عشان لما اجي اقفله من غير ما اكتب حاجه فيه تقول empty
                    insertDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text)
                        .then((value) {
                      getFromDtabase(database).then((value) {
                        Navigator.pop(context);
                        // setState(() {
                        //   isBottomsheet = false;
                        //   iconData = Icons.add;
                        //   task = value;
                        //   print(task);
                        // });
                      });
                    });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) =>
                        Container(
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
                                    prefixIcon: Icon(Icons.title),
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
                                    prefixIcon: Icon(Icons.watch_later),
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
                                        lastDate:
                                        DateTime.parse('2023-01-01'))
                                        .then((value) {
                                      print(DateFormat.yMMMd().format(value!));
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_month),
                                    labelText: ' Task dat',
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
                  )
                      .closed
                      .then((value) {
                    isBottomsheet = false;
                    // setState(() {
                    //   iconData = Icons.add;
                    // });
                  });
                  isBottomsheet = true;
                  // setState(() {
                  //   iconData = Icons.accessibility_new_outlined;
                  // });
                }
              },
              child: Icon(iconData),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeIndex(index);

                // setState(() {
                //   currentIndex = index;
                // });
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
            ),
          );
        },
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

  Future getFromDtabase(database) async {
    return await database!.rawQuery('SELECT * FROM tasks');
  }
}
