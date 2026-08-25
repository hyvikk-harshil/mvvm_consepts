import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mvvm_consepts/features/currency/repositorys/icurrency_repository.dart';
import '../models/currency_model.dart';

class CurrencyRepository implements IcurrencyRepository {
  ///free public API endpoint with no API key required
  final String _url = 'https://er-api.com';

  @override
  Future<CurrencyModel> fetchLiveRates() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if(response.statusCode==200){
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        return CurrencyModel.fromJson(decodedData);
      }else{
        throw Exception('Server returned an error status: ${response.statusCode}');
      }
    }catch(e){
      /// Catch generate when no Internet,Timeout,FormatException/TypeError etc..
      throw Exception('Failed to connect to exchange rate server... check Network.');
    }
  }
}