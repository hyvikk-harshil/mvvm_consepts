import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/repository/product_repository.dart';

class DeleteProductViewmodel extends ChangeNotifier{
  final ProductRepository _repository = ProductRepository();
  bool isDeleting = false;
  bool isDeleteSuccess = false;
  String errorMessage = '';

  Future<void> removeProduct(int id) async {
    isDeleting = true;
    errorMessage = '';
    isDeleteSuccess = false;
    notifyListeners();

    try {
      await _repository.deleteProduct(id);
      isDeleteSuccess = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }
}