import 'package:firebase_production_client_app/controller/home_controller.dart';
import 'package:firebase_production_client_app/pages/login_page.dart';
import 'package:firebase_production_client_app/pages/product_description_page.dart';
import 'package:firebase_production_client_app/widget/drop_down_btn.dart';
import 'package:firebase_production_client_app/widget/multi_select_dropdown.dart';
import 'package:firebase_production_client_app/widget/product_cart.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchProducts();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'Electronics Store',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        GetStorage box = GetStorage();
                        box.erase();
                        Get.offAll(const LoginPage());
                      },
                      icon: const Icon(Icons.logout)),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: controller.productcategories.length,
                    // itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.filterByCategory(
                              controller.productcategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Chip(
                              label: Text(
                                  controller.productcategories[index].name ??
                                      'Error')),
                          // label: Text('category')),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: DropDownBtn(
                          items: const ['Rs:High to Low', 'Rs:Low to High'],
                          selectedItemtext: 'sort',
                          onSelected: (selected) {
                            controller.sortByPrice(
                                ascending: selected == 'Rs:Low to High'
                                    ? true
                                    : false);
                          }),
                    ),
                    Flexible(
                      child: MultiSelectDropDown(
                          items: const [
                            'Samsung',
                            'Sony',
                            'OnePlus',
                            'Apple',
                          ],
                          onSelectionChanged: (selectedItems) {
                            if (kDebugMode) {
                              print(selectedItems);
                              controller.filterByBrand(selectedItems);
                            }
                          }),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            crossAxisCount: 2),
                    itemCount: controller.productsShowInUi.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        onTap: () {
                          Get.to(const ProductDescription(), arguments: {
                            'data': controller.productsShowInUi[index]
                          });
                        },
                        name: controller.productsShowInUi[index].name ??
                            'no name',
                        imageUrl:
                            controller.productsShowInUi[index].image ?? 'url',
                        price: controller.productsShowInUi[index].price ?? 00,
                        offerTag: '30% off',
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
