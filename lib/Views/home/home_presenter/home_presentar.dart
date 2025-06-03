
// presenters/home_presenter.dart
import 'package:flutter/material.dart';

import '../../../Contract/home_contract_page.dart';
import '../../../Models/products_model/home_model_page.dart';
import '../../../Models/products_model/product_model_page.dart';

class HomePresenterImpl implements HomePresenter {
  final HomeView view;

  HomePresenterImpl(this.view);

  @override
  void loadHomeData() {
    view.showLoading();

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      final homeData = _getMockData();
      view.hideLoading();
      view.showData(homeData);
    });
  }

  @override
  void onCategoryClicked(Category category) {
    // Navigate to category page
    print('Category clicked: ${category.name}');
  }

  @override
  void onProductClicked(Product product) {
    // Navigate to product details
    print('Product clicked: ${product.name}');
  }

  @override
  void onFlashSaleViewAll() {
    // Navigate to flash sale page
    print('Flash Sale View All clicked');
  }

  HomeModel _getMockData() {
    return HomeModel(
      banners: [
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
        'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
        'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=800',
      ],
      categories: [
        Category(id: '1', name: 'Electronics', icon: '📱', color: Colors.blue),
        Category(id: '2', name: 'Fashion', icon: '👗', color: Colors.pink),
        Category(id: '3', name: 'Grocery', icon: '🛒', color: Colors.green),
        Category(id: '4', name: 'Machine Tools', icon: '🔧', color: Colors.orange),
        Category(id: '5', name: 'Home & Garden', icon: '🏠', color: Colors.purple),
        Category(id: '6', name: 'Sports', icon: '⚽', color: Colors.red),
        Category(id: '7', name: 'Books', icon: '📚', color: Colors.brown),
        Category(id: '8', name: 'Beauty', icon: '💄', color: Colors.teal),
      ],
      flashSaleProducts: [
        Product(id: '1', name: 'Smartphone XYZ', image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300', price: 15000, originalPrice: 20000, discount: 25, rating: 4.5, category: 'Electronics'),
        Product(id: '2', name: 'Wireless Headphones', image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300', price: 2500, originalPrice: 3500, discount: 29, rating: 4.3, category: 'Electronics'),
        Product(id: '3', name: 'Smart Watch', image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300', price: 8000, originalPrice: 12000, discount: 33, rating: 4.7, category: 'Electronics'),
      ],
      groceryProducts: [
        Product(id: '4', name: 'Organic Rice 5kg', image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300', price: 450, originalPrice: 500, discount: 10, rating: 4.2, category: 'Grocery'),
        Product(id: '5', name: 'Fresh Vegetables Pack', image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300', price: 250, originalPrice: 300, discount: 17, rating: 4.0, category: 'Grocery'),
        Product(id: '6', name: 'Premium Tea 250g', image: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=300', price: 180, originalPrice: 220, discount: 18, rating: 4.4, category: 'Grocery'),
      ],
      machineTools: [
        Product(id: '7', name: 'Electric Drill Set', image: 'https://images.unsplash.com/photo-1581090464777-f3220bbe1b8b?w=300', price: 3500, originalPrice: 4200, discount: 17, rating: 4.6, category: 'Tools'),
        Product(id: '8', name: 'Tool Kit 50 Pieces', image: 'https://images.unsplash.com/photo-1609205264895-04a33c2e3c07?w=300', price: 1800, originalPrice: 2200, discount: 18, rating: 4.3, category: 'Tools'),
        Product(id: '9', name: 'Welding Machine', image: 'https://images.unsplash.com/photo-1590736969955-71cc94901144?w=300', price: 8500, originalPrice: 10000, discount: 15, rating: 4.5, category: 'Tools'),
      ],
      justForYouProducts: [
        Product(id: '10', name: 'Cotton T-Shirt', image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300', price: 650, originalPrice: 800, discount: 19, rating: 4.1, category: 'Fashion'),
        Product(id: '11', name: 'Bluetooth Speaker', image: 'https://images.unsplash.com/photo-1545454675-3531b543be5d?w=300', price: 1200, originalPrice: 1500, discount: 20, rating: 4.4, category: 'Electronics'),
        Product(id: '12', name: 'Running Shoes', image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300', price: 2800, originalPrice: 3500, discount: 20, rating: 4.6, category: 'Sports'),
      ],
    );
  }
}
