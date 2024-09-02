import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
        builder: (context){
      return const Scaffold(
        backgroundColor: Color(0xff1e1c99),
        body: Center(
          child: Text("Welcome to SoftCodix",
            style: TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white),),
        ),
      );
    });
  }
}
