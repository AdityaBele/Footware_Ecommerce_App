import 'package:client_footware/bindings/home_binding.dart';
import 'package:client_footware/bindings/login_binding.dart';
import 'package:client_footware/bindings/purchase_binding.dart';
import 'package:client_footware/bindings/register_binding.dart';
import 'package:client_footware/home_page.dart';
import 'package:client_footware/login_page.dart';
import 'package:client_footware/product_description_page.dart';
import 'package:client_footware/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'firebase.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => HomePage(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          binding: RegisterBinding(),
        ),
        GetPage(
          name: '/product',
          page: () => ProductDescriptionPage(),
          binding: PurchaseBindind(),
        ),
      ],
      initialBinding: LoginBinding(),
    );
  }
}
