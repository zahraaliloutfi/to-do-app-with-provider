import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/shared/bloc_observer.dart';
import 'models/todo/home_layout.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),

    );
  }
}

main() {
  Bloc.observer = MyBlocObserver();
  // Use cubits...
  return runApp(const MyApp());
}
