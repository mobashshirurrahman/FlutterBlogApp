import 'package:blog_app/views/create_blog.dart';
import 'package:blog_app/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🔥 Blog',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
