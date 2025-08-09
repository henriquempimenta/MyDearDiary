import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:my_dear_diary/data/repositories/diary_repository.dart';
import 'package:my_dear_diary/presentation/views/dashboard_page.dart';
import 'package:my_dear_diary/presentation/viewmodels/dashboard_vm.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  group('DashboardPage', () {
    testWidgets('displays Dashboard title', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<DiaryRepository>(
          create: (_) => DiaryRepository(),
          child: MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => DashboardViewModel(diaryRepository: DiaryRepository()),
              child: const DashboardPage(),
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
