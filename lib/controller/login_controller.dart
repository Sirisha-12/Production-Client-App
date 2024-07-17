import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_production_client_app/model/user/user.dart';
import 'package:firebase_production_client_app/pages/home_page.dart';
// import 'package:firebase_production_client_app/model/user/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameController = TextEditingController();
  TextEditingController registerNumberController = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();

  TextEditingController loginNumberController = TextEditingController();

  bool otpFieldShown = false;
  int? otpSent;
  int? otpEnter;
  User? loginUser;

  @override
  void onReady() {
    Map<String, dynamic>? user = box.read('loginUser');
    if (user != null) {
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  addUser() {
    try {
      if (otpSent == otpEnter) {
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameController.text,
          number: int.parse(registerNumberController.text),
        );

        final userJson = user.toJson();
        doc.set(userJson);

        Get.snackbar('Success', 'User addded succesfully',
            colorText: Colors.green);
        registerNumberController.clear();
        registerNameController.clear();
        otpController.clear();
      } else {
        Get.snackbar('Error', 'OTP does not match', colorText: Colors.red);
      } // setValuesDefault();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      if (kDebugMode) {
        print(e);
      }
    }
  }

  sendOtp() {
    try {
      if (registerNameController.text.isEmpty ||
          registerNumberController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill the field', colorText: Colors.red);
        return;
      }
      final random = Random();
      int otp = (1000 + random.nextInt(9000));
      if (kDebugMode) {
        print(otp);
      }
      if (otp != null) {
        otpFieldShown = true;
        otpSent = otp;

        Get.snackbar('Sucess', 'OTP sent sucessfully', colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'OTP failed', colorText: Colors.red);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      update();
    }
  }

  Future<void> loginPhone() async {
    try {
      String phoneNumber = loginNumberController.text;
      if (phoneNumber.isNotEmpty) {
        var querSnapshot = await userCollection
            .where('number', isEqualTo: int.tryParse(phoneNumber))
            .limit(1)
            .get();
        if (querSnapshot.docs.isNotEmpty) {
          var userDoc = querSnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('loginUser', userData);
          loginNumberController.clear();
          Get.to(const HomePage());
          Get.snackbar('Success', 'Login Successful', colorText: Colors.green);
        } else {
          Get.snackbar('Error', 'User not found ,please register',
              colorText: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Please enter a valid number',
            colorText: Colors.red);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
