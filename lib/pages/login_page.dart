import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:softcodixserviceproviders/consts.dart';
import 'package:softcodixserviceproviders/pages/home_page.dart';
import 'package:softcodixserviceproviders/services/local_auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _authService.authchack(context),
        initialData: false,
        builder: (context, snapshot) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Visibility(
                  visible: snapshot.data ?? false,
                  child: const Text(
                      " Biometric Services are not available, you can\nauthenticate using your pin/password/pattern.")),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: /*!(snapshot.data ?? false)*/ true,
                child: Column(
                  children: [
                    Visibility(
                      visible: !(snapshot.data ?? false),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DEFAULT_DIALOG_BUTTON_COLOR,
                          minimumSize: const Size(0, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          openFingerprintSettings();
                        },
                        child: const Text(
                          'Add new Fingerprint',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DEFAULT_DIALOG_BUTTON_COLOR,
                        minimumSize: const Size(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        bool isAuthenticated =
                            await _authService.authenticateWithBiometrics();
                        if (isAuthenticated) {
                          Get.offAll(HomePage());
                        } else {
                          Get.snackbar(backgroundColor: const Color(0xff1e1c99),
                              "Error", "Authentication failed",colorText: Colors.white);
                        }
                      },
                      child: const Text(
                        'Authenticate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ));
        },
      ),
    );
  }

  void openFingerprintSettings() async {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.SECURITY_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  Future<void> initiateLocalAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    // ···
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }
}
