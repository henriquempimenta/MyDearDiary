import 'package:flutter/material.dart';
import 'app_router.dart';

class MyDearDiaryApp extends StatelessWidget {
  const MyDearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'My Dear Diary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
