import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/repository/product_repository.dart';
import '../models/product_model.dart';

class ProductDetailViewModel extends ChangeNotifier{
  final ProductRepository _productRepository = ProductRepository();
  ProductModel? product;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadProductDetail(int id) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try{
      product = await _productRepository.getProductByID(id);
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }


  /// Professionally handle business logic calculations here
  Map<String, dynamic> generateRazorpayOptions(ProductModel product) {
    const String razorpayKey = 'rzp_test_TNxuCTsvMY0WVX';
    final double amountInPaise = (product.price * 100).toDouble();

    return {
      'key': razorpayKey,
      'amount': amountInPaise,
      'name': 'Hyvikk Solutions',
      'description': 'Purchase: ${product.title}',
      'retry': {'enabled': true, 'max_count': 1},
      //'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm'] // Remove 'google pay' string literal as it is implicitly covered via native UPI hooks
      }
    };
  }
}


