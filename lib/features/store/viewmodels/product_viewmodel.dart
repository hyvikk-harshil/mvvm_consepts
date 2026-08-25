import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/models/product_model.dart';
import 'package:mvvm_consepts/features/store/repository/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<ProductModel> product = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> loadProduct()async{
    isLoading=true;
    errorMessage='';
    notifyListeners();

    try{
      product = await _repository.fetchProducts();
    }catch(error){
      errorMessage = error.toString();
    }finally{
      isLoading = false;
      notifyListeners();
    }
  }
}