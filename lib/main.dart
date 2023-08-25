import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tasks/db/db_helper.dart';
import 'package:tasks/ui/ui.dart';
import 'package:tasks/services/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await con.getTasks();
  await DBhelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeServices().theme,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: const Home(),
    );
  }
}
