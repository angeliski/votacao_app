import 'package:flutter/material.dart';
import 'package:votacao_app/routes/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votação App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new AuthScreen(),
    );
  }
}
