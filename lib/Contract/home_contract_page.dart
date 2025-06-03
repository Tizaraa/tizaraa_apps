// contracts/home_contract.dart
import '../Models/products_model/home_model_page.dart';
import '../Models/products_model/product_model_page.dart';

abstract class HomeView {
  void showLoading();
  void hideLoading();
  void showData(HomeModel data);
  void showError(String message);
}

abstract class HomePresenter {
  void loadHomeData();
  void onCategoryClicked(Category category);
  void onProductClicked(Product product);
  void onFlashSaleViewAll();
}