import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/Banner_model.dart';

Future<List<BannerModel>> fetchBanners() async {
  final response = await http.get(
    Uri.parse('https://admin.kushinirestaurant.com/api/banners/'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => BannerModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load banners');
  }
}
