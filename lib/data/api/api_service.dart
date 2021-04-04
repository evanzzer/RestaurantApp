import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';

class ApiService {
  final String baseUrl = 'https://restaurant-api.dicoding.dev/'; // Made public for testing purposes
  http.Client _client = new http.Client(); // Made public for testing purposes

  http.Client get client => _client;
  void setClientForTest(http.Client client) {
    _client = client;
  }

  Future<RestaurantResult> fetchList() async {
    final response = await _client.get("${baseUrl}list/");
    if (response.statusCode == 200) {
      return RestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  Future<SearchResult> fetchSearch(String query) async {
    final response = await _client.get("${baseUrl}search?q=$query");
    if (response.statusCode == 200) {
      return SearchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  Future<DetailResult> fetchDetails(String id) async {
    final response = await _client.get("${baseUrl}detail/$id");
    print("${baseUrl}detail/$id");
    if (response.statusCode == 200) {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load the restaurant list.');
    }
  }

  String fetchPictureMediumUrl(String pictureId) => "${baseUrl}images/medium/$pictureId";

  String fetchPictureLargeUrl(String pictureId) => "${baseUrl}images/large/$pictureId";
}