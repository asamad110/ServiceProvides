import 'package:get/get.dart';
import 'package:softcodixserviceproviders/pages/login_page.dart';

class SplashController extends GetxController{
  @override
  void onReady() {
    navigateToLoginPage();
    super.onReady();
  }

  Future navigateToLoginPage() async{
    await Future.delayed(const Duration(seconds: 3));
    Get.off(()=> const LoginPage());

  }
}