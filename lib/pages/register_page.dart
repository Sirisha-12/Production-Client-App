import 'package:firebase_production_client_app/controller/login_controller.dart';
import 'package:firebase_production_client_app/pages/login_page.dart';
import 'package:firebase_production_client_app/widget/otp_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
            body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.blueGrey[35]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create your account!!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.registerNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Your Name',
                  labelText: 'Your Name',
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller.registerNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Your Mobile Number',
                  labelText: 'Mobile Number',
                  prefixIcon: const Icon(Icons.phone_android),
                ),
              ),
              const SizedBox(height: 20),
              OtpTextField(
                onComplete: (otp) {
                  controller.otpEnter = int.tryParse(otp);
                },
                otpController: controller.otpController,
                visible: controller.otpFieldShown,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (controller.otpFieldShown) {
                    controller.addUser();
                  } else {
                    controller.sendOtp();
                  }
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple),
                child: Text(controller.otpFieldShown ? 'Register' : 'Send OTP'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.to(const LoginPage());
                },
                child: const Text('Login'),
              )
            ],
          ),
        ));
      },
    );
  }
}
