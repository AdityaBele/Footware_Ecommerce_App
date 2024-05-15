import 'dart:math';

import 'package:client_footware/Controller/home_controller.dart';
import 'package:client_footware/home_page.dart';
import 'package:client_footware/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registeMobNumber = TextEditingController();

  TextEditingController loginMobNumbeCrtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShow = false;
  int? otpSend;
  int? otpEnter;

  late User loginUser;

  late SharedPreferences prefs;



  // @override
  // void onReady(){
  //   Map<String,dynamic> user = box.read('loginUser');
  //   if(user != null){
  //     loginUser = User.fromJson(user);
  //     print(user);
  //     Get.to(() => const HomePage());
  //   }
  //   super.onReady();
  // }

  @override
  void onInit() {
    super.onInit();
    initLogin();
  }

  void initLogin() async {
    prefs = await SharedPreferences.getInstance();

    userCollection = firestore.collection('user');

    Future.delayed(Duration(seconds: 0), () {
      Map<String,dynamic> user = box.read('loginUser');
      loginUser = User.fromJson(user);
      Get.toNamed('/home');
    });
  }

  addUser() {
    try {
      if (otpSend == otpEnter) {DocumentReference doc = userCollection.doc();
        User user = User(
            id: doc.id,
            name: registerNameCtrl.text,
            mob_number: int.parse(registeMobNumber.text));
        final userJson = user.toJson();
        doc.set(userJson);
        Get.snackbar(
          'success',
          'Add successfully',
          colorText: Colors.green,
          duration: Duration(seconds: 2),
        );
        registerNameCtrl.clear();
        registeMobNumber.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', 'otp Incorrect', colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error 404', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  sendOtp() async {
    try {
      if (registeMobNumber.text.isEmpty || registerNameCtrl.text.isEmpty) {
        Get.snackbar('Error', 'Please fill Name & Number',
            colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = 1000 + random.nextInt(9000);

      String mobileNumber = registeMobNumber.text;
      String url =
          'https://www.fast2sms.com/dev/bulkV2?authorization=dnAseyGpJxZYiK39kfWRMEBNbhXmvwzglDta7456oIr0LTcCjPZ32DlROc49gAXmKejnHJtapGYvP1FV&route=otp&variables_values=$otp&flash=0&numbers=$mobileNumber';
      Response response = await GetConnect().get(url);

      print(otp);
      //? will send otp and check its send successfully or not
      if (response.body['message'][0] == 'SMS sent successfully.') {
        otpFieldShow = true;
        otpSend = otp;
        Get.snackbar('OTP Send', 'Your OTP send successfully',
            colorText: Colors.green);
      } else {
        Get.snackbar('Error 404', 'otp not send', colorText: Colors.red);
      }
    } catch (e) {
      print(e);
    } finally {
      update();
    }
  }

  Future<void> LoginWithPhone() async {
    try {
      String phoneNumber = loginMobNumbeCrtrl.text;

      if (phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection
            .where('mob number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          loginMobNumbeCrtrl.clear();

          // Cache the User data
          await prefs.setString('id', userData['id']);
          await prefs.setString('name', userData['name']);
          await prefs.setInt('mob_number', userData['mob number']);
          await prefs.setBool('logged_in', true);

          // if (!Get.isRegistered<HomeController>()) {
          //   Get.put(HomeController());
          // }

          Get.toNamed('/home');
          // Get.snackbar('Success ', 'login Successfully', colorText: Colors.green);
        } else {
          Get.snackbar('error ', 'please register your Number',
              colorText: Colors.red);
        }
      } else {
        Get.snackbar(
          'error',
          'please enter phone number',
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar('error ', e.toString(), colorText: Colors.red);
      print("LoginWithPhone $e");
    }
  }
}
