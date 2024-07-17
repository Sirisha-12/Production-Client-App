import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_production_client_app/model/product/product.dart';
import 'package:firebase_production_client_app/model/product_category/product_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  List<Product> products = [];
  List<Product> productsShowInUi = [];
  List<ProductCategory> productcategories = [];

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    await fetchCategory();
    await fetchProducts();
    super.onInit();
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrivedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrivedProducts);
      productsShowInUi.assignAll(products);

      Get.snackbar("Success", "Product fetch successfully",
          colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      if (kDebugMode) {
        print(e);
      }
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrivedCategories = categorySnapshot.docs
          .map((doc) =>
              ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      productcategories.clear();
      productcategories.assignAll(retrivedCategories);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      if (kDebugMode) {
        print(e);
      }
    } finally {
      update();
    }
  }

  filterByCategory(String category) {
    productsShowInUi.clear();
    productsShowInUi =
        products.where((product) => product.category == category).toList();
    update();
  }

  filterByBrand(List<String> brands) {
    if (brands.isNotEmpty) {
      productsShowInUi = products;
    } else {
      List<String> lowerCaseBrands =
          brands.map((brand) => brand.toLowerCase()).toList();
      productsShowInUi = products
          .where((product) =>
              lowerCaseBrands.contains(product.brand?.toLowerCase() ?? ''))
          .toList();
    }
    update();
  }

  sortByPrice({required bool ascending}) {
    List<Product> sortedProducts = List<Product>.from(productsShowInUi);
    sortedProducts.sort((a, b) => ascending
        ? a.price!.compareTo(b.price!)
        : b.price!.compareTo(a.price!));
    productsShowInUi = sortedProducts;
    update();
  }
}
