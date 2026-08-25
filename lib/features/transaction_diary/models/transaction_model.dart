class TransactionModel {
final String id;
final String title;
final double amount;
final DateTime date;
final bool isExpence;

TransactionModel(
    {
      required this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.isExpence
    });

///Convert Object to Map
Map<String, dynamic>toMap(){
      return {
        "id": id,
        "title": title,
        "amount": amount,
        "data": date.toIso8601String(),
        "isExpence": isExpence ? 1 : 0,
      };
}

///Convert map back into the Object
factory TransactionModel.fromMap(Map<String, dynamic> map){
      return TransactionModel(
          id: map["id"],
          title: map["title"],
          amount: map["amount"],
        date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
        isExpence: map['isExpence'] == 1,
      );
}
}