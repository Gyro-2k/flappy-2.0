import 'package:flutter/material.dart';
import 'homepage.dart';

void main() //    B)    B:|
{
  runApp(MyBirdApp());
}

class MyBirdApp extends StatelessWidget {
  const MyBirdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: HomePage(),
    );
  }
}
