import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({@required this.apiService}) {
    _fetchQuery("");
  }

  SearchResult _result;
  String _message = '';
  ResultState _state;

  SearchResult get result => _result;
  String get message => _message;
  ResultState get state => _state;

  void setQuery(String query) {
    _fetchQuery(query);
  }

  Future<dynamic> _fetchQuery(String query) async {
    try {
      if (query.length == 0 || query == null) {
        _state = ResultState.Init;
        notifyListeners();
        return null;
      }
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.fetchSearch(query);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'No Restaurant has been found';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _result = restaurant;
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