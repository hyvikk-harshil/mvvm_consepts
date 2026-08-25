class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  ProductModel({required this.id, required this.title, required this.price, required this.description, required this.category, required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> map){
    return ProductModel(
        id: map['id'],
        title: map['title'],
        price: (map['price'] as num).toDouble(),
        description: map['description'],
        category: map['category'],
        image: map['image']
    );
  }
}