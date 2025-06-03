// models/product_model.dart
import 'dart:ui';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double originalPrice;
  final int discount;
  final double rating;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.category,
  });
}

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}