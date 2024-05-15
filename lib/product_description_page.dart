import 'package:client_footware/Controller/purchase_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'model/product/product.dart';

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(
      assignId: true,
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Product Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  product.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  product.description ?? '',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300, height: 1.5),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Rs : ${product.price ?? ''}',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: ctrl.addressController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      label: Text("Enter Billing Address"),
                      hintText: 'Your Billing Address Please!'),
                  maxLines: 4,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.indigoAccent),
                      onPressed: () {
                        ctrl.submitOrder(price: product.price ?? 0, item: product.name ??'', description: product.description ?? '');
                      },
                      child: Text(
                        'Buy',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
