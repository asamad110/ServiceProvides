import 'package:get/get.dart';
import 'package:softcodixserviceproviders/controllers/service_provider_controller.dart';
import 'package:softcodixserviceproviders/services/http_service.dart';

Future<void> registerServices() async {
  Get.put(
    HTTPService(),
  );
}

Future<void> registerControllers() async {
  Get.put(
    ServiceProviderController(),
  );
}

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
