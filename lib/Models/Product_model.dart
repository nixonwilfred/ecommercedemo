// class Addon {
//   final String featuredImage;
//
//   Addon({required this.featuredImage});
//
//   factory Addon.fromJson(Map<String, dynamic> json) {
//     return Addon(
//       featuredImage: json['featured_image'],
//     );
//   }
// }
//
// class Product {
//   final int id;
//   final String name;
//   final double salePrice;
//   final String featuredImage;
//   final List<Addon> addons;
//   bool inWishlist;
//
//   Product({
//     required this.id,
//     required this.name,
//     required this.salePrice,
//     required this.featuredImage,
//     required this.addons,
//     this.inWishlist = false,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       salePrice: json['sale_price'].toDouble(),
//       featuredImage: json['featured_image'],
//       addons: json['addons'] != null
//           ? (json['addons'] as List)
//           .map((addon) => Addon.fromJson(addon))
//           .toList()
//           : [],
//       inWishlist: json['in_wishlist'] ?? false,
//     );
//   }
// }

import 'package:get/get.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String caption;
  final String featuredImage;
  final List<String> images;
  final double salePrice;
  final double mrp;
  RxBool inWishlist;
  final bool isActive;
  final double discount;
  final bool variationExists;
  final List<Variation> variations;
  final List<Addon> addons;
  final bool available;
  final String availableFrom;
  final String availableTo;
  final int avgRating;
  final String productType;
  final int stock;
  final int category;
  final double taxRate;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.caption,
    required this.featuredImage,
    required this.images,
    required this.salePrice,
    required this.mrp,
    bool inWishlist=false,
    required this.isActive,
    required this.discount,
    required this.variationExists,
    required this.variations,
    required this.addons,
    required this.available,
    required this.availableFrom,
    required this.availableTo,
    required this.avgRating,
    required this.productType,
    required this.stock,
    required this.category,
    required this.taxRate,
  }): inWishlist = inWishlist.obs;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      caption: json['caption'],
      featuredImage: json['featured_image'],
      images: List<String>.from(json['images']),
      salePrice: json['sale_price'].toDouble(),
      mrp: json['mrp'].toDouble(),
      inWishlist: json['in_wishlist'] ?? false,
      isActive: json['is_active'],
      discount: double.parse(json['discount']),
      variationExists: json['variation_exists'],
      variations: json['variations'] != null
          ? (json['variations'] as List)
          .map((v) => Variation.fromJson(v))
          .toList()
          : [],
      addons: json['addons'] != null
          ? (json['addons'] as List).map((a) => Addon.fromJson(a)).toList()
          : [],
      available: json['available'],
      availableFrom: json['available_from'],
      availableTo: json['available_to'],
      avgRating: json['avg_rating'],
      productType: json['product_type'],
      stock: json['stock'],
      category: json['category'],
      taxRate: json['tax_rate'].toDouble(),
    );
  }
}

class Variation {
  final int id;
  final String variationName;
  final String featuredImage;
  final double salePrice;
  final int stock;
  final bool showStatus;
  final int showingOrder;

  Variation({
    required this.id,
    required this.variationName,
    required this.featuredImage,
    required this.salePrice,
    required this.stock,
    required this.showStatus,
    required this.showingOrder,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      variationName: json['variation_name'],
      featuredImage: json['featured_image'],
      salePrice: json['sale_price'].toDouble(),
      stock: json['stock'],
      showStatus: json['show_status'],
      showingOrder: json['showing_order'] ?? 0,
    );
  }
}

class Addon {
  final int id;
  final String name;
  final String description;
  final String featuredImage;
  final double price;
  final int stock;
  final bool isActive;
  final double taxRate;

  Addon({
    required this.id,
    required this.name,
    required this.description,
    required this.featuredImage,
    required this.price,
    required this.stock,
    required this.isActive,
    required this.taxRate,
  });

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      featuredImage: json['featured_image'],
      price: json['price'].toDouble(),
      stock: json['stock'],
      isActive: json['is_active'],
      taxRate: json['tax_rate'].toDouble(),
    );
  }
}

