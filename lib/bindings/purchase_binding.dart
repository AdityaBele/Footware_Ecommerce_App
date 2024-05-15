import 'package:client_footware/Controller/purchase_controller.dart';
import 'package:get/get.dart';


class PurchaseBindind extends Bindings {
  @override
  void dependencies() {
    Get.put(PurchaseController());
  }
}