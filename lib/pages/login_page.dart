import 'package:firebase_production_client_app/controller/login_controller.dart';
import 'package:firebase_production_client_app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.maxFinite,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blueGrey[30]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.loginNumberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Enter your Mobile Number',
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone_android),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.loginPhone();
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple),
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(const RegisterPage());
                  },
                  child: const Text('Register new account'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
