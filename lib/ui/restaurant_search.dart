import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/provider/search_provider.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';
import 'package:restaurant_app/utils/result_state.dart';
import 'package:restaurant_app/widgets/card_restaurant.dart';

class RestaurantSearchPage extends StatefulWidget {
  @override
  _RestaurantSearchPageState createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  TextEditingController _query = new TextEditingController();

  _retrieveList(BuildContext context, SearchProvider state) {
    if (_query.text.isEmpty) {
      SnackBar snackBar = SnackBar(
        content: Text('Search query is still empty'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      FocusScope.of(context).unfocus();
      state.setQuery(_query.text);
    }
  }

  Widget _buildList(BuildContext context) =>
      OrientationBuilder(
        builder: (context, orientation) =>
          Consumer<SearchProvider>(
            builder: (context, state, _) {
              return Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                8.0))),
                        child: ListTile(
                          title: TextField(
                            controller: _query,
                            decoration: InputDecoration(hintText: 'Search', border: InputBorder.none),
                            textInputAction: TextInputAction.search,
                            onEditingComplete: () => _retrieveList(context, state),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(0.0),
                            width: 32,
                            child: IconButton(
                              icon: Icon(Icons.search_rounded),
                              onPressed: () => _retrieveList(context, state),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      child: SingleChildScrollView(
                        child: _buildContent(context, orientation, state),
                      ),
                    ),
                  )
                ],
              );
            }
          ),
      );

  Widget _buildContent(BuildContext context, Orientation orientation, SearchProvider state) {
    if (state.state == ResultState.Init) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 96.0),
            SizedBox(height: 12.0),
            Text('Search for exciting places to eat.'),
          ],
        ),
      );
    } else if (state.state == ResultState.Loading) {
      return Container(
        padding: const EdgeInsets.only(top: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state.state == ResultState.HasData) {
      return GridView.builder(
        shrinkWrap: true,
        primary: false,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (orientation == Orientation.portrait ? 2 : 4),
        ),
        itemCount: state.result.restaurants.length,
        itemBuilder: (context, index) {
          var restaurant = state.result.restaurants[index];
          return CardRestaurant(
            restaurant: restaurant,
            onPressed: () => Navigation.intentWithData(RestaurantDetailPage.routeName, restaurant),
          );
        }
      );
    } else if (state.state == ResultState.NoData) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_sharp, color: Colors.blueGrey, size: 64),
            SizedBox(height: 4.0),
            Text(
                state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1
            ),
          ],
        ),
      );
    } else if (state.state == ResultState.Error) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_sharp, color: Colors.red, size: 64),
            SizedBox(height: 4.0),
            Text(
                "Error: ${state.message}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: Text('Search Restaurants'),
        ),
        body: _buildList(context),
      );

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }
}