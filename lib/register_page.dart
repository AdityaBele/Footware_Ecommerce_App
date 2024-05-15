import 'package:client_footware/Controller/login_controller.dart';
import 'package:client_footware/login_page.dart';
import 'package:client_footware/widget/otp_txt_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      assignId: true,
      builder: (ctrl) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create Your Account !!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: ctrl.registerNameCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.perm_identity_sharp),
                      labelText: 'Name',
                      hintText: 'Enter Your Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: ctrl.registeMobNumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.phone_iphone),
                      labelText: 'Mobile Number',
                      hintText: 'Enter Your Number'),
                ),
                SizedBox(
                  height: 20,
                ),
                OtpTextField(
                  otpController: ctrl.otpController,
                  visble: ctrl.otpFieldShow,
                  onComplete: (otp) {
                    ctrl.otpEnter = int.tryParse(otp?? '0000');
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (ctrl.otpFieldShow) {
                        ctrl.addUser();
                      } else {
                        ctrl.sendOtp();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white),
                    child: Text(
                      ctrl.otpFieldShow ? 'register' : 'send otp',
                    )),
                TextButton(onPressed: () {
                  Get.toNamed('/login');
                }, child: Text('Login'))
              ],
            ),
          ),
        );
      },
    );
  }
}
