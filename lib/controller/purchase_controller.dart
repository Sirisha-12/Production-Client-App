import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_production_client_app/controller/login_controller.dart';
import 'package:firebase_production_client_app/model/user/user.dart';
import 'package:firebase_production_client_app/pages/home_page.dart';
import 'package:flutter/foundation.dart';
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
    super.onInit();
    orderCollection = firestore.collection('orders');
  }

  submitOrder({
    required String item,
    required double price,
    required String description,
  }) {
    // orderPrice = price;
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    Razorpay _razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_0WT1Q0c7Wc7F52',
      'amount': price * 100,
      'name': item,
      'description': 'description',
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment is successful', colorText: Colors.green);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Error', 'Payment failed,${response.message}',
        colorText: Colors.red);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User? loginUse = Get.find<LoginController>().loginUser;
    try {
      if (transactionId != null) {
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'address': orderAddress,
          'item': itemName,
          'price': orderPrice,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
        });
        if (kDebugMode) {
          print('Order created sucessfully: ${docRef.id}');
          showOrderSuccessDialog(docRef.id);
        }
        Get.snackbar('Success', 'Order is successful', colorText: Colors.green);
      } else {
        Get.snackbar('Error', 'Order failed', colorText: Colors.red);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to Register User: $Error');
      }
      Get.snackbar('Error', 'Order failed', colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String orderId) {
    Get.defaultDialog(
        title: 'Order Success',
        content: Text('Your order Id is $orderId'),
        confirm: ElevatedButton(
            onPressed: () {
              Get.off(const HomePage());
            },
            child: const Text('Close')));
  }
}
