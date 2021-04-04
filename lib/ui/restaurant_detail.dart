import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';
import 'package:restaurant_app/provider/details_provider.dart';
import 'package:restaurant_app/utils/result_state.dart';

class RestaurantDetailPage extends StatelessWidget {
  static const String routeName = '/restaurant_details';

  final Restaurant restaurant;

  const RestaurantDetailPage({@required this.restaurant});

  Widget _buildTile(BuildContext context, String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.arrow_forward, size: 16.0),
      SizedBox(width: 4.0),
      Text(text, style: Theme.of(context).textTheme.subtitle1),
    ],
  );

  Widget _buildReview(BuildContext context, CustomerReview review) =>
      Material(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          margin: const EdgeInsets.all(6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(review.name, style: Theme.of(context).textTheme.headline6),
                        Text(review.date),
                        SizedBox(height: 6.0),
                        Text(
                            review.review,
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: restaurant == null ? [Container()] : [
                  restaurant.pictureId == null
                      ? Container(child: Icon(Icons.error))
                      : Hero(
                        tag: restaurant.id,
                        child: Image.network(
                          ApiService().fetchPictureLargeUrl(restaurant.pictureId),
                          fit: BoxFit.fill,
                        ),
                      ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.5)]
                      )
                    ),
                  ),
                ],
              ),
              title: restaurant == null ? Text("Error") : Text(restaurant.name),
              centerTitle: true,
            ),
          ),
        ],
        body: OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
              child: Consumer<DetailsProvider>(
                builder: (context, provider, _) {
                  if (provider.state == ResultState.Loading) {
                    return Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (provider.state == ResultState.HasData) {
                    var restaurant = provider.result.restaurant;
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_location, color: Colors.green),
                                    SizedBox(width: 4.0),
                                    Text(restaurant.city),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.orange),
                                    SizedBox(width: 4.0),
                                    Text(restaurant.rating.toString())
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.category, color: Colors.blueGrey),
                              SizedBox(width: 4.0),
                              Text(restaurant.categories.join(", ")),
                            ],
                          ),
                          Divider(color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                            child: Text(restaurant.description),
                          ),
                          Divider(color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                            child: Text(
                              "Foods:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: restaurant.menus.foods.map((e) => _buildTile(context, e)).toList()
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                            child: Text(
                              "Drinks:",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: restaurant.menus.drinks.map((e) => _buildTile(context, e)).toList(),
                          ),
                          Divider(color: Colors.grey),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                            child: Text(
                              "Customer Review",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                  (orientation == Orientation.portrait ? 2 : 4),
                                ),
                                itemCount: restaurant.customerReviews.length,
                                itemBuilder: (context, index) {
                                  var review = restaurant.customerReviews[index];
                                  return _buildReview(context, review);
                                }
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (provider.state == ResultState.Error || provider.state == ResultState.NoData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_sharp, color: Colors.red, size: 64),
                        SizedBox(height: 4.0),
                        Text(
                            'Data failed to load\n' +
                                'Error: ${provider.message}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.subtitle1
                        ),
                      ],
                    );
                  } else {
                    return Text('');
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}