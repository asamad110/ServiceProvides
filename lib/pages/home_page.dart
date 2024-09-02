import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:softcodixserviceproviders/consts.dart';
import 'package:softcodixserviceproviders/controllers/assets_controller.dart';
import 'package:softcodixserviceproviders/models/service_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AssetsController assetsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(
        context,
      ),
      body: SafeArea(
          child: Obx(
        () => _buildUI(
          context,
        ),
      )),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xff1e1c99),
      scrolledUnderElevation: 5.0,
      title: const Text("Service Providers",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            showAddUpdateServiceDialog(null);
          },
          icon: const Icon(
            Icons.add,color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    if (assetsController.loadingRoot.isTrue) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        child: _trackedAssetsList(
          context,
        ),
      );
    }
  }

  Widget _trackedAssetsList(
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: ListView.builder(
        itemCount: assetsController.serviceProvidersData.length,
        itemBuilder: (context, index) {
          ServiceProvider trackedAsset =
              assetsController.serviceProvidersData[index];
          return Card(
            elevation: 0.0,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 15.0),
              title: Text(
                assetsController.getServiceProviderName(trackedAsset.id ?? 0),
              ),
              subtitle: Text(assetsController
                  .getServiceProviderComment(trackedAsset.id ?? 0)),
              trailing: SizedBox(
                width: 100.0,
                child: Row(
                  children: [
                    IconButton(
                      color: Color(0xff1e1c99),
                      icon: const Icon(CupertinoIcons.pencil_circle),
                      onPressed: () {
                        showAddUpdateServiceDialog(trackedAsset);
                      },
                    ),
                    IconButton(
                      color: Colors.red[900],
                      icon: const Icon(CupertinoIcons.delete),
                      onPressed: () {
                        showConfirmationDialog(() {
                          assetsController
                              .deleteServiceProvider(trackedAsset.id ?? 0);
                          setState(() {
                            assetsController.serviceProvidersData
                                .removeAt(index);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDetailDialog(trackedAsset?.id ?? 0);
              },
            ),
          );
        },
      ),
    );
  }

  void showAddUpdateServiceDialog(ServiceProvider? serviceProvider) {
    TextEditingController nameController =
        TextEditingController(text: serviceProvider?.name);
    TextEditingController commentController =
        TextEditingController(text: serviceProvider?.comments);

    Get.dialog(
        barrierDismissible: false,
        Obx(
          () => Dialog(
            backgroundColor: Colors.transparent,
            child: PopScope(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: dialogHeadingTextWidget(
                          "${serviceProvider != null ? "Update" : "Add"} Service Provider"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(alignment: Alignment.center, children: [
                      Visibility(
                        visible: assetsController.loadingInDialog.isTrue,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                              controller: nameController,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Comment',
                              ),
                              controller: commentController,
                            )
                          ],
                        ),
                      )
                    ]),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        if (serviceProvider != null) {
                          //Update
                          serviceProvider.name = nameController.text;
                          serviceProvider.comments = commentController.text;
                          assetsController.updateServiceProvider(
                            serviceProvider,
                                () {
                              setState(() {});
                              Get.back();
                            },
                          );
                        } else {
                          //Add
                          ServiceProvider serviceProvider = ServiceProvider(
                              name: nameController.text,
                              comments: commentController.text,
                              deleted: false);

                          assetsController.addServiceProvider(
                            serviceProvider,
                            (serviceProvider) {
                              assetsController.serviceProvidersData
                                  .add(serviceProvider);
                              Get.back();
                            },
                          );
                        }
                      },
                      child: Center(
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: DEFAULT_DIALOG_BUTTON_COLOR,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            style: TextStyle(
                                color: Colors.white, fontSize: BODY_SIZE),
                            serviceProvider != null ? "Update" : "Add",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void showDetailDialog(int serviceProviderID) {
    assetsController.getServiceProviderDetails(serviceProviderID);
    Get.dialog(barrierDismissible: false, Obx(() {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: PopScope(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: dialogHeadingTextWidget("Service Provider Details"),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Stack(children: [
                    Visibility(
                      visible: assetsController.loadingInDialog.isTrue,
                      child: const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !assetsController.loadingInDialog.isTrue,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                            initialValue: assetsController
                                .serviceProviderDetails.value?.name,
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Comment',
                            ),
                            initialValue: assetsController
                                .serviceProviderDetails?.value?.comments,
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Created At',
                            ),
                            initialValue: DateFormat('dd-MM-yyyy hh:mm a')
                                .format(DateTime.parse(assetsController
                                        .serviceProviderDetails
                                        .value
                                        ?.createdAt ??
                                    "2024-08-27T20:06:47.421152Z")),
                            enabled: false,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Creator',
                            ),
                            initialValue: assetsController
                                .serviceProviderDetails.value?.creator
                                .toString(),
                            enabled: false,
                          )
                        ],
                      ),
                    )
                  ]),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xff1e1c99),
                          //color: Colors.blueGrey[400],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        style: TextStyle(color: Colors.white),
                        "Dismiss",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }

  void showConfirmationDialog(Function? onDismiss()) {
    Get.dialog(Dialog(
        backgroundColor: Colors.transparent,
        child: PopScope(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      dialogHeadingTextWidget("Warning"),
                      const SizedBox(height: 15),
                      Text(
                        style: TextStyle(fontSize: BODY_SIZE),
                        "Are you sure, You want to remove this service provider?",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      //Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                style: TextStyle(
                                    fontSize: BODY_SIZE, color: Colors.white),
                                'NO',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DEFAULT_DIALOG_BUTTON_COLOR,
                                minimumSize: const Size(0, 45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                style: TextStyle(
                                    fontSize: BODY_SIZE, color: Colors.white),
                                'YES',
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                                backgroundColor: DEFAULT_DIALOG_BUTTON_COLOR,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                onDismiss.call();
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}

Widget dialogHeadingTextWidget(String s) {
  return Text(
    style: TextStyle(fontSize: HEADING_SIZE),
    s,
    textAlign: TextAlign.center,
  );
}
