import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/diary_repository.dart';
import 'app_router.dart';

class MyDearDiaryApp extends StatelessWidget {
  const MyDearDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DiaryRepository(),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'My Dear Diary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
