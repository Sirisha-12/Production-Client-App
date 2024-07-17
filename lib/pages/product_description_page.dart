import 'package:firebase_production_client_app/controller/purchase_controller.dart';
import 'package:firebase_production_client_app/model/product/product.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key});

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];

    return GetBuilder<PurchaseController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Product Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Expanded(
                        child: Image.network(
                          product.image ?? '',
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                          // height: 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      product.name ?? '',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      product.description ?? '',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Rs:${product.price ?? ''}",
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: controller.addressController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Billing address',
                        hintText: 'Enter your billing address',
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.indigo),
                          onPressed: () {
                            controller.submitOrder(
                                item: product.name ?? '',
                                price: product.price ?? 0,
                                description: product.description ?? '');
                          },
                          child: const Text('Buy now')),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
