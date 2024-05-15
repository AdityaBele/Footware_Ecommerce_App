import 'package:client_footware/Controller/login_controller.dart';
import 'package:client_footware/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PurchaseController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  @override
  void onInit() {
    orderCollection = firestore.collection('order');
    super.onInit();

  }


  submitOrder(
      {required double price,
      required String item,
      required String description
      }) {

    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;
    addressController.clear();

    Razorpay _razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_RBGIDQxhkgjP8L',
      'amount': price * 100,
      'name': item,
      'description': description,
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.open(options);

  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId, orderCollection: orderCollection, itemName: itemName, orderPrice: orderPrice, orderAddress: orderAddress);
    // Do something when payment succeeds
    Get.snackbar('Succcess', 'Payment is Successful',colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.snackbar('Succcess', '${response.message}',colorText: Colors.red);
  }

}

Future<void> orderSuccess({required String? transactionId,
  required CollectionReference orderCollection,
  required String itemName,
  required double orderPrice,
  required String orderAddress,}) async {
  User? loginUse = Get.find<LoginController>().loginUser;
  try {
    if (transactionId != null) {
      DocumentReference docRef = await orderCollection.add({
        'costumer': loginUse.name ?? '',
        'phone': loginUse.mob_number ?? '',
        'item': itemName,
        'price': orderPrice,
        'address': orderAddress,
        'transactionId': transactionId,
        'dateTime': DateTime.now().toString(),
      });
      print('oder Created Succesfully: ${docRef.id}');
      showOrderSuccessDailog(docRef.id);
      Get.snackbar('Success', 'Order Place Successfully', colorText: Colors.green);
    } else {
      Get.snackbar('error', 'please fill all field', colorText: Colors.red);
    }
  } catch (error) {
    Get.snackbar('wrong', 'error', colorText: Colors.red);
  }
}

void showOrderSuccessDailog(String orderId){
  Get.defaultDialog(
    title: "Order Success",
    content: Text("Your OrderId is $orderId"),
    confirm: ElevatedButton(onPressed: (){
      Get.offNamed('/home');
      }, child:Text('close'))
  );
}


