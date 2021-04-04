import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({@required this.databaseHelper}) {
    _getFavorites();
  }

  ResultState _state;
  ResultState get state => _state;
  
  String _message = '';
  String get message => _message;
  
  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;
  
  void _getFavorites() async {
    _favorites = await databaseHelper.getFavorites();
    if (_favorites.length > 0) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = "You haven't favorited any restaurant yet!";
    }
    notifyListeners();
  }
  
  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorite(restaurant);
      _getFavorites();
    } catch (e) {
      _state = ResultState.Error;
      _message = e.toString();
      notifyListeners();
    }
  }
  
  Future<bool> isFavorited(String id) async {
    final favorited = await databaseHelper.getFavoriteById(id);
    return favorited.isNotEmpty;
  }
  
  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorites();
    } catch (e) {
      _state = ResultState.Error;
      _message = "Error: ${e.toString()}";
      notifyListeners();
    }
  }
}