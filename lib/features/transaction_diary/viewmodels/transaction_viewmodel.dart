import 'package:flutter/widgets.dart';
import 'package:mvvm_consepts/features/transaction_diary/models/transaction_model.dart';
import 'package:mvvm_consepts/features/transaction_diary/repositorys/transaction_repository.dart';

class TransactionViewModel extends ChangeNotifier{
  final List<TransactionModel> _transaction = [];
  List<TransactionModel> get transaction => List.unmodifiable(_transaction);
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final TransactionRepository _repository = TransactionRepository();

  TransactionViewModel(){
    _initData();
  }

  ///fetch saved data on app launch
  Future<void> _initData()async{
    _isLoading=true;
    notifyListeners();

    final savedList = await _repository.loadTransactions();
    _transaction.addAll(savedList);

    _isLoading=false;
    notifyListeners();
  }

  ///calculate total balance
  double get totalBalance{
      double total = 0.0;
      for(var tx in _transaction){
        if(tx.isExpence){
          total -= tx.amount;
        }else{
          total += tx.amount;
        }
      }
      return total;
  }

  ///add Transaction and notify UI
  Future<void> addTransaction(String title,double amount,bool isExpence) async {
    final newTx = TransactionModel(
      id:DateTime.now().millisecondsSinceEpoch.toString(),
      title:title,
      date:DateTime.now(),
      amount:amount,
      isExpence: isExpence,
    );
    _transaction.add(newTx);
    notifyListeners();

    //persist data in background
    await _repository.saveTransactions(_transaction);
  }

  Future<void> removeTransaction(String id) async {
    _transaction.removeWhere((tx)=>tx.id == id);
    notifyListeners();

    await _repository.saveTransactions(_transaction);
  }
}