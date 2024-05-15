import 'package:client_footware/Controller/login_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}