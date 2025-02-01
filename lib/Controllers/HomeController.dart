import 'package:get/get.dart';

import '../Models/Product_model.dart';
import '../Services/FetchWishListApi.dart';
import '../Services/fetchProducts.dart';
import '../Services/toggleWishlistApi.dart';
import '../Utilities/tokenStorage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var productList = <Product>[].obs;
  var filteredProductList = <Product>[].obs;  // List to hold the filtered products
  var wishlist = <Product>[].obs;
  var searchQuery = ''.obs;






  // Change bottom navigation index
  void changeIndex(int index) {
    selectedIndex.value = index;
    if (index == 1) { // Assuming index 1 is the Wishlist screen
      loadWishlist(); // Load the wishlist
    }
  }

  // Load all products
  Future<void> loadProducts() async {
    try {
      var products = await fetchProducts();
      productList.assignAll(products);
      filteredProductList.assignAll(products);  // Initially show all products
    } catch (e) {
      Get.snackbar("Error", "Failed to load products: $e");
    }
  }

  // Load wishlist from API
  Future<void> loadWishlist() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please log in to view your wishlist.");
        return;
      }
      var wishlistItems = await fetchWishlistAPI(token);
      wishlist.assignAll(wishlistItems);
    } catch (e) {
      Get.snackbar("Error", "Failed to load wishlist: $e");
    }
  }
  Future<void> manageWishlist(Product product) async {

    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please log in to use this feature.");
        return;
      }

      final message = await toggleWishlistAPI(token, product.id);

      // Toggle product's inWishlist state
      product.inWishlist.value = !product.inWishlist.value;

      // Update wishlist based on the new state
      if (product.inWishlist.value) {
        if (!wishlist.contains(product)) {
          wishlist.add(product); // Add product to wishlist
        }
      } else {
        wishlist.removeWhere((p) => p.id == product.id);      }

      productList.refresh();
      wishlist.refresh();// Refresh the product list to reflect the state change
      Get.snackbar("Wishlist", message, duration: Duration(milliseconds: 650), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  // Update search query and filter the product list based on it
  void updateSearchQuery(String query) {
    searchQuery.value= query;
    if (query.isEmpty) {
      filteredProductList.assignAll(productList);  // Show all products when search is cleared
    } else {
      filteredProductList.assignAll(productList.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());  // Filter based on product name
      }).toList());
    }
  }

  // Add product to wishlist and navigate to WishlistScreen
  void addToWishlist(Product product) {
    manageWishlist(product);
    loadWishlist();
    changeIndex(1); // Navigate to Wishlist screen
  }
}


