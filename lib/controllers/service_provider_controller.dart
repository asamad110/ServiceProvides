import 'package:get/get.dart';
import 'package:softcodixserviceproviders/models/service_provider.dart';
import 'package:softcodixserviceproviders/services/http_service.dart';

class ServiceProviderController extends GetxController {
  RxList<ServiceProvider> serviceProvidersData = <ServiceProvider>[].obs;
  RxBool loadingRoot = false.obs;
  RxBool loadingInDialog = false.obs;
  final Rx<ServiceProvider?> serviceProviderDetails =
      (null as ServiceProvider?).obs;

  @override
  void onInit() {
    super.onInit();
    _getAllServiceProviders();
  }

  Future<void> _getAllServiceProviders() async {
    loadingRoot.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("serviceprovider");
    List<dynamic> jsonData = responseData;
    List<ServiceProvider> items =
        jsonData.map((item) => ServiceProvider.fromJson(item)).toList();
    serviceProvidersData.value = items ?? [];
    loadingRoot.value = false;
  }

  Future<void> getServiceProviderDetails(int id) async {
    loadingInDialog.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("serviceprovider/$id");
    serviceProviderDetails.value = ServiceProvider.fromJson(responseData);
    loadingInDialog.value = false;
  }

  Future<void> updateServiceProvider(
      ServiceProvider serviceProvider, Function() onDismiss) async {
    loadingInDialog.value = true;
    HTTPService httpService = Get.find();
    var response = await httpService.patch(
        "serviceprovider/${serviceProvider.id}/", serviceProvider.toJson());
    onDismiss.call();
    loadingInDialog.value = false;

  }

  Future<void> addServiceProvider(ServiceProvider serviceProvider,
      Function(ServiceProvider serviceProvider) onDismiss) async {
    loadingInDialog.value = true;
    HTTPService httpService = Get.find();
    var response =
        await httpService.post("serviceprovider/", serviceProvider.toJson());
    ServiceProvider item = ServiceProvider.fromJson(response);
    onDismiss.call(item);
    loadingInDialog.value = false;
  }
  Future<void> deleteServiceProvider(int id) async {
    loadingRoot.value = true;
    HTTPService httpService = Get.find();
    await httpService.delete("serviceprovider/$id/");
    loadingRoot.value = false;
  }

  String getServiceProviderName(int id) {
    ServiceProvider? data = getServiceProviderById(id);
    return 'Name: ${data?.name ?? "Not Available"}';
  }

  String getServiceProviderComment(int id) {
    ServiceProvider? data = getServiceProviderById(id);
    return 'Comments: ${data?.comments ?? "Not Available"}';
  }

  ServiceProvider? getServiceProviderById(int id) {
    return serviceProvidersData.firstWhereOrNull((e) => e.id == id);
  }
}
