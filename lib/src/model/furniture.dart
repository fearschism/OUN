import './furniture_color.dart';

class Furniture {
  String id;
  String author;
  String title;
  String description;
  String price;
  int quantity;
  //double score;
  String city;
  List<String> images;
  bool isFavorite;
  List<FurnitureColor> colors;

  Furniture({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.price,
    this.quantity = 1,
    //required this.score,
    required this.city,
    required this.images,
    this.isFavorite = false,
    required this.colors,
  });
}
