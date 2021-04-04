import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class RestaurantFavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) => Consumer<DatabaseProvider>(
            builder: (context, provider, _) {
              if (provider.state == ResultState.HasData) {
                return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (orientation == Orientation.portrait ? 2 : 4),
                    ),
                    itemCount: provider.favorites.length,
                    itemBuilder: (context, index) {
                      var restaurant = provider.favorites[index];
                      return CardRestaurant(
                        restaurant: restaurant,
                        onPressed: () => Navigation.intentWithData(RestaurantDetailPage.routeName, restaurant),
                      );
                    }
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_sharp, color: Colors.red, size: 64),
                      SizedBox(height: 4.0),
                      Text(
                          provider.message,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
    );
  }

}