import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoflutter/ui/home_page.dart';
import 'package:todoflutter/util/colors.dart';
import 'package:todoflutter/view_model/tasklistviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';

import 'data/adapter.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoListModelAdapter());
  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskListViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: Consumer<TaskListViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            theme: ThemeData.light().copyWith(
              primaryColor: AppColors.primaryColor,
              // Additional light theme settings
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.blackColor,
                // Additional dark theme settings
              ),
            ),
            themeMode: viewModel.isDarkEnabled
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }
}
