import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvvm_consepts/features/store/models/product_model.dart';

import '../../../const/network/network_manager.dart';

final String baseUrl = "https://fakestoreapi.com";
final NetworkBoundClient _client = NetworkBoundClient();

class ProductRepository {
  Future<List<ProductModel>> fetchProducts()async{
    final response = await _client.get(Uri.parse("$baseUrl/products"));
    if(response.statusCode == 200){
      List<dynamic> data = json.decode(response.body);
     return data.map((toElement)=>ProductModel.fromJson(toElement)).toList();
    }
    else{
    return throw Exception('fail to load products');
    }
  }

  Future<ProductModel> getProductByID(int id) async {
    final response = await _client.get(Uri.parse("$baseUrl/products/$id"),);
    if(response.statusCode == 200){
      return ProductModel.fromJson(json.decode(response.body));
    }
    else{
      throw Exception('fail to load product detail');
    }
  }

  Future<ProductModel> addProduct(ProductModel newProduct) async{
    final response = await _client.post(
      Uri.parse("$baseUrl/Products"),
      headers: {'content-Type': 'application/json'},
      body: json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'category': newProduct.category,
        'image': newProduct.image
      }),
    );

    if(response.statusCode==200 || response.statusCode==201){
      return ProductModel.fromJson(json.decode(response.body));
    }
    else{
      throw Exception('Product adding fail : ${response.statusCode}');
    }
  }

  Future<ProductModel> updateProduct(int id, ProductModel updatedProduct) async {
    final response = await _client.put(Uri.parse("$baseUrl/products/$id"),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'id':id,
      'title': updatedProduct.title,
      'price': updatedProduct.price,
      'description': updatedProduct.description,
      'category': updatedProduct.category,
      'image': updatedProduct.image
    }),
    );

    if(response.statusCode == 200){
      return ProductModel.fromJson(json.decode(response.body));
    }else{
      throw Exception("Updation failed...");
    }
  }


  Future<void> deleteProduct(int id) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/products/$id'),
    );

    // The image shows that a successful deletion returns a 200 status code
    if (response.statusCode != 200) {
      throw Exception('Failed to delete product from the server');
    }
  }
}