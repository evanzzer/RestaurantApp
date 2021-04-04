import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';
import 'api_service_test.mocks.dart';

/// Reference for this: https://flutter.dev/docs/cookbook/testing/unit/mocking
@GenerateMocks([http.Client])
void main() {
  ApiService apiService = new ApiService();

  group('Api Service Test', () {
    test('Test if the restaurant list is being fetched', () async {
      apiService.setClientForTest(new http.Client());
      expect(await apiService.fetchList(), isA<RestaurantResult>());
    });

    test('Test if the restaurant search query is being fetched', () async {
      apiService.setClientForTest(new http.Client());
      expect(await apiService.fetchSearch('Melting'), isA<SearchResult>());
    });

    test('Test if anonymous search query returns an empty body', () async {
      apiService.setClientForTest(new http.Client());
      var response = await apiService.fetchSearch('abdjfafjdadof adsfadjvvfjadsjvfjadosjfvoajsdklvfjaljdfvjaf'); // Never ever a restaurant like this
      expect(response.restaurants.isEmpty, true);
    });

    test('Test if details search query return an error', () async {
      apiService.setClientForTest(MockClient());

      when(apiService.client.get('${apiService.baseUrl}detail/test'))
          .thenAnswer((_) async => http.Response('404 Not Found', 404));

      expect(apiService.fetchDetails('test'), throwsException);
    });

    test('Test if details search query return a thing', () async {
      apiService.setClientForTest(MockClient());

      when(apiService.client.get('${apiService.baseUrl}detail/test'))
          .thenAnswer((_) async => http.Response('''{
              "error": false,
              "message": "success",
              "restaurant": {
                  "id": "test",
                  "name": "Test Restaurant",
                  "description": "Test Description",
                  "city": "Medan",
                  "address": "Jln. Pandeglang no 19",
                  "pictureId": "14",
                  "categories": [
                      {
                          "name": "Test"
                      }
                  ],
                  "menus": {
                      "foods": [
                          {
                              "name": "Test"
                          }
                      ],
                      "drinks": [
                          {
                              "name": "Test"
                          }
                      ]
                  },
                  "rating": 4.0,
                  "customerReviews": [
                      {
                          "name": "Test",
                          "review": "Test Review",
                          "date": "01 January 1970"
                      }
                  ]
              }
          }''', 200));

      expect(await apiService.fetchDetails('test'), isA<DetailResult>());
    });
  });
}