import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionRepository{
  static const String _storageKey = "store_transactions";

  //save entire list to local device storage
  Future<void> saveTransactions(List<TransactionModel> transactions)async {
    final pref = await SharedPreferences.getInstance();

    //convert list of objects to list of JSON maps, then to a single str
    final String encodeData = jsonEncode(
        transactions.map((tx) => tx.toMap()).toList()
    );
    await pref.setString(_storageKey, encodeData);
  }

    //load the list from local device storage
    Future<List<TransactionModel>> loadTransactions() async{
      final pref = await SharedPreferences.getInstance();
      final String? encodedData = pref.getString(_storageKey);

      if(encodedData == null) return [];

      // Decode back to structured maps, then map them back to TransactionModel objects.
      final List<dynamic> decodedData = jsonDecode(encodedData);
      return decodedData.map((item) => TransactionModel.fromMap(item)).toList();
    }
}