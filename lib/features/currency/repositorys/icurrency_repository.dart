import '../models/currency_model.dart';

abstract class IcurrencyRepository {
  Future<CurrencyModel> fetchLiveRates();
}