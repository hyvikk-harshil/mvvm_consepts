import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/currency/repositorys/icurrency_repository.dart';
import '../models/currency_model.dart';

class CurrencyViewModel extends ChangeNotifier{
  //CurrencyRepository _repository = CurrencyRepository();
  final IcurrencyRepository _repository;
  CurrencyViewModel(this._repository);

  CurrencyModel? _currencyModelData;
  bool _isLoading = false;
  String? _errorMessage;

  ///Getters for the UI
  CurrencyModel? get currencyModelData => _currencyModelData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ///Fetch data safely
  Future<void> loadExchangeRates() async {
    _isLoading = true;
    _errorMessage = null; //clear previous errors
    notifyListeners();

    try{
      _currencyModelData = await _repository.fetchLiveRates();
    }catch(e){
      _errorMessage = e.toString().replaceAll('Exception : ', '');
    }finally{
      _isLoading=false;
      notifyListeners();
    }
  }

  ///calculate currency conversation
  double convert(double amount,String targetCurrency){
    if(_currencyModelData==null) return 0.0;
    double rate = _currencyModelData!.rates[targetCurrency] ?? 1.0;
    return amount * rate;
  }
}