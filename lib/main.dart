import 'package:flutter/material.dart';
import 'package:tododapp/screens/listadd.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData.dark(),
      home: TodoList(),
    );

  }
}
