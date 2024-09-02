import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:softcodixserviceproviders/pages/home_page.dart';
import 'package:softcodixserviceproviders/pages/login_page.dart';
import 'package:softcodixserviceproviders/pages/splash_page.dart';
import 'package:softcodixserviceproviders/utils.dart';

void main() async {
  await registerServices();
  await registerControllers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      routes: {
        "/splash": (context) => SplashPage(),
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
      },
      initialRoute: "/splash",
    );
  }
}


