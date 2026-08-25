import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/repository/product_repository.dart';
import '../models/product_model.dart';

class AddProductViewModel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  bool isSubmitting = false;
  String errorMessage = '';
  bool isSuccess = false;

  Future<void> submitProduct(String title, double price, String imageUrl) async {
    isSubmitting = true;
    errorMessage = '';
    isSuccess = false;
    notifyListeners();

    try
    {
      //create a temporary domain model
      final  tempProduct = ProductModel(
        id: 45,
        title: title,
        price: price,
        image: imageUrl,
          description: 'A wonder full new product',
          category: 'electronic'
      );
      await _repository.addProduct(tempProduct);
      isSuccess = true;
    }
    catch (e){
      errorMessage = e.toString();
    }
    finally{
      isSubmitting = false;
      notifyListeners();
    }
  }
}