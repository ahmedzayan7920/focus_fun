import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/views/home_view.dart';


late SharedPreferences sharedPreferences;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Fun Space',
      home: HomeView(),
    );
  }
}