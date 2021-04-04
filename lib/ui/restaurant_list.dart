import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class RestaurantListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text('Restaurant App'),
        ),
        body: OrientationBuilder(
            builder: (context, orientation) => Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                if (provider.state == ResultState.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else if (provider.state == ResultState.HasData) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                        (orientation == Orientation.portrait ? 2 : 4),
                      ),
                      itemCount: provider.result.restaurants.length,
                      itemBuilder: (context, index) {
                        var restaurant = provider.result.restaurants[index];
                        return CardRestaurant(
                          restaurant: restaurant,
                          onPressed: () =>
                              Navigator.pushNamed(
                                context, RestaurantDetailPage.routeName,
                                arguments: restaurant,
                              ),
                        );
                      }
                  );
                } else if (provider.state == ResultState.NoData || provider.state == ResultState.Error) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_sharp, color: Colors.red,
                            size: 64),
                        SizedBox(height: 4.0),
                        Text(
                            'Data failed to load\n' +
                                'Error: ${provider.message}',
                            textAlign: TextAlign.center,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('');
                }
              },
            )
        ),
      );
}