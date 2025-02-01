class BannerModel {
  final int id;
  final String name;
  final String imageUrl;

  BannerModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
    );
  }
}
