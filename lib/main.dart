import 'package:flutter/material.dart';
import 'home_layout.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),

    );
  }
}

main() {
  return runApp(const MyApp());
}
