// models/home_model.dart
import 'package:tizaraa/Models/products_model/product_model_page.dart';

class HomeModel {
  final List<String> banners;
  final List<Category> categories;
  final List<Product> flashSaleProducts;
  final List<Product> groceryProducts;
  final List<Product> machineTools;
  final List<Product> justForYouProducts;

  HomeModel({
    required this.banners,
    required this.categories,
    required this.flashSaleProducts,
    required this.groceryProducts,
    required this.machineTools,
    required this.justForYouProducts,
  });
}