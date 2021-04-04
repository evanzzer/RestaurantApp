import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_list.dart';

Widget createHomeScreen() => ChangeNotifierProvider<RestaurantProvider>(
  create: (context) => RestaurantProvider(apiService: ApiService()),
  child: MaterialApp(
    home: RestaurantListPage(),
  ),
);

void main() {
  group('Restaurant Test Page', () {
    testWidgets('Test if the Grid View show up', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}