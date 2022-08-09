import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http ;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-7e779-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json'); 
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false; 
    notifyListeners();

  }

  Future saveOrCreate(Product product) async {

    isSaving = true;
    notifyListeners();

    if (product.id == null) {
       //TODO Crear
    } else {
      //Actualizar
      await updateProduct(product);
    }


    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct(Product product) async {

    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
     await http.put(url, body: product.toJson() );

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;

  }
  
}