import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {

  String id;
  String name;
  String description;
  String image;
  double price;
  int idCategory;
  int quantity;
  List<Product> toList = [];

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.idCategory,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] is int ? json["id"].toString() : json['id'],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    price: json['price'] is String ? double.parse(json["price"]) : isInteger(json["price"]) ? json["price"].toDouble() : json['price'],
    idCategory: json["id_category"] is String ? int.parse(json["id_category"]) : json["id_category"],
    quantity: json["quantity"],
  );

  Product.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      Product product = Product.fromJson(item);
      toList.add(product);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "price": price,
    "id_category": idCategory,
    "quantity": quantity,
  };

  static bool isInteger(num value) => value is int || value == value.roundToDouble();

}
