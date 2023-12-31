import 'package:flutter/material.dart';
import 'package:piano_tiles_2/presentation/views/start_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      home: StartView(),
    );
  }
}