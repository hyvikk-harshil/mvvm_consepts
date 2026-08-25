import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/repository/product_repository.dart';
import '../models/product_model.dart';

class UpdateProductViewmodel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  bool isUpdating = false;
  String errorMessage = '';
  bool isSuccess = false;

  Future<void> modifyProduct(int id, String title, double price, String imageUrl) async {
    isUpdating = true;
    errorMessage = '';
    isSuccess = false;
    notifyListeners();

    try{
      final updatedData = ProductModel(id:id, title:title, price:price, image:imageUrl, description: '', category: '');
      await _repository.updateProduct(id, updatedData);
      isSuccess = true;
    }catch(e){
      errorMessage = e.toString();
    }finally{
      isUpdating = false;
      notifyListeners();
    }
  }
}