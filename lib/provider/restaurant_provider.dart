import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider({@required this.apiService}) {
    _fetchAllList();
  }

  RestaurantResult _restaurantResult;
  String _message = '';
  ResultState _state;

  RestaurantResult get result => _restaurantResult;
  String get message => _message;
  ResultState get state => _state;

  Future<dynamic> _fetchAllList() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.fetchList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      if (e.toString().contains("No address associated with hostname"))
        _message = "Pastikan terdapat koneksi internet";
      else _message = e.toString();
      notifyListeners();
      return null;
    }
  }
}