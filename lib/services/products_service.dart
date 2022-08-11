import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http ;

class ProductsService extends ChangeNotifier {

  final String _baseUrl = 'flutter-varios-7e779-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;
  late Product selectedProduct;
  File? newPictureFile;

  final _storage = FlutterSecureStorage();

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    }); 
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
       await createProduct(product);
    } else {
      await updateProduct(product);
    }


    isSaving = false;
    notifyListeners();

  }

  Future<String> updateProduct(Product product) async {

    final url = Uri.https(_baseUrl, 'products/${product.id}.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
     await http.put(url, body: product.toJson() );

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;

  }

  Future<String>  createProduct(Product product) async {

    final url = Uri.https(_baseUrl, 'products.json', {
      'auth': await _storage.read(key: 'token') ?? ''
    });
    final resp = await http.post(url, body: product.toJson() );
    final decodedData = json.decode(resp.body);
    
    product.id = decodedData['name'];

    products.add(product);

    return product.id!;

  }
  
  void updatedSelectedProductImage(String path) {

    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();

  }

  Future<String?> uploadImage() async{
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dmqgdno4p/image/upload');

    final imageIploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
    final uploadPreset = http.MultipartFile.fromString('upload_preset', 'jioabjby');

    imageIploadRequest.files.add(uploadPreset);
    imageIploadRequest.files.add(file);

    final streamResponse = await imageIploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode!= 201) {
      print('ALgo salio mal');
      print(resp.body);
      
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];

  }
}