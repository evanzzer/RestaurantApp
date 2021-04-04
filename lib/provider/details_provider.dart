import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';
import 'package:restaurant_app/utils/result_state.dart';

class DetailsProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  DetailsProvider({@required this.apiService, @required this.id}) {
    _fetchDetails();
  }

  DetailResult _result;
  String _message = '';
  ResultState _state;

  DetailResult get result => _result;
  String get message => _message;
  ResultState get state => _state;

  Future<dynamic> _fetchDetails() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final details = await apiService.fetchDetails(id);
      if (details.restaurant != null) {
        _state = ResultState.HasData;
        notifyListeners();
        return _result = details;
      } else {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = "Data Restaurant tidak dapat ditemukan";
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