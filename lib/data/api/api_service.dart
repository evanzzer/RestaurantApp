import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev/';

  Future<RestaurantResult> fetchList() async {
    final response = await http.get("${_baseUrl}list/");
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  Future<SearchResult> fetchSearch(String query) async {
    final response = await http.get("${_baseUrl}search?q=$query");
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  Future<DetailResult> fetchDetails(String id) async {
    final response = await http.get("${_baseUrl}detail/$id");
    print("${_baseUrl}detail/$id");
    if (response.statusCode == 200) {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  String fetchPictureMediumUrl(String pictureId) => "${_baseUrl}images/medium/$pictureId";

  String fetchPictureLargeUrl(String pictureId) => "${_baseUrl}images/large/$pictureId";
}