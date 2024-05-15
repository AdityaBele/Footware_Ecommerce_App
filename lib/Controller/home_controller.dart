import 'package:client_footware/model/product_category/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../model/product/product.dart';

class HomeController extends GetxController {
  FirebaseFirestore? firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategory = [];

  @override
  void onInit() async {
    super.onInit();

    productCollection = FirebaseFirestore.instance.collection('products');
    categoryCollection = FirebaseFirestore.instance.collection('category');
    await fetchCategory();
    await fetchProduct();
  }

  fetchProduct() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrieveProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrieveProducts);
      productShowInUi.assignAll(products);
     //Get.snackbar('Success', 'Product fetch Successfully',
          //colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Server Error', e.toString(), colorText: Colors.red);
      print("Error HomeController $e");
    } finally {
      update();
    }
  }


  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrieveProducts = categorySnapshot.docs
          .map((doc) => ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategory.clear();
      productCategory.assignAll(retrieveProducts);
      //Get.snackbar('Success', 'Category fetch Successfully',
          //colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Server Error', e.toString(), colorText: Colors.red);
      print("fetchCategory $e");
    } finally {
      update();
    }
  }


  filterByCategory(String category){
    productShowInUi.clear();
    productShowInUi = products.where((product) => product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUi = products;
    } else {
      List<String> lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toList();
      productShowInUi = products.where((product) => lowerCaseBrands.contains(product.brand?.toLowerCase())).toList();
    }
    update();
  }
  
  sortByPrice({required bool ascending}){
    List<Product> sortProducts = List<Product>.from(productShowInUi);
    sortProducts.sort((a,b)=> ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!));
    productShowInUi = sortProducts;
    update();
  }



}