class CurrencyModel {
  final String baseCode;
  final Map<String, double> rates;

  CurrencyModel({required this.baseCode, required this.rates});

  factory CurrencyModel.fromJson(Map<String, dynamic> json){
    var rawRates = json['rates'] as Map<String, dynamic>;
    Map<String, double> parsedRates = {};
    rawRates.forEach((key,value){
    parsedRates[key] = (value as num).toDouble();
    });

    return CurrencyModel(
        baseCode: json['base_code'] ?? 'USD',
        rates: parsedRates,
    );
  }
}