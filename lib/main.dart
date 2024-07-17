import 'package:firebase_production_client_app/controller/home_controller.dart';
import 'package:firebase_production_client_app/controller/login_controller.dart';
import 'package:firebase_production_client_app/controller/purchase_controller.dart';
import 'package:firebase_production_client_app/pages/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCMET2Z34EPI7euU62kGBOpjxsAq6aVjLw",
            authDomain: "fir-productionapp.firebaseapp.com",
            projectId: "fir-productionapp",
            storageBucket: "fir-productionapp.appspot.com",
            messagingSenderId: "690507808482",
            appId: "1:690507808482:web:cdbfeb05120d3ec4e3a8bb",
            measurementId: "G-W3CKWHBQS6"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCb0Nd6U1NLa5iSvL3WMeoxGzCxYcHpi9c",
            appId: "1:690507808482:android:7d56f0dd28ca8c10e3a8bb",
            messagingSenderId: "690507808482",
            projectId: "fir-productionapp"));
  }
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PurchaseController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
