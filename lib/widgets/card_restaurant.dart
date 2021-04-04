import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/provider/database_provider.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  final Function onPressed;

  const CardRestaurant({Key key, this.restaurant, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer<DatabaseProvider>(
        builder: (context, provider, _) {
          return FutureBuilder<bool>(
            future: provider.isFavorited(restaurant.id),
            builder: (context, snapshot) {
              var isFavorited = snapshot.data ?? false;
              return Material(
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  margin: const EdgeInsets.all(6.0),
                  child: InkWell(
                    onTap: onPressed,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0)
                                ),
                                child: restaurant.pictureId == null
                                    ? Container(child: Icon(Icons.error))
                                    : Hero(
                                      tag: restaurant.id,
                                      child: Image.network(
                                        ApiService().fetchPictureMediumUrl(restaurant.pictureId),
                                        fit: BoxFit.cover,
                                        height: 120,
                                      ),
                                    ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                title: Text(
                                  restaurant.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                subtitle: Column(
                                  children: [
                                    SizedBox(height: 4.0),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.add_location, color: Colors.green),
                                        SizedBox(width: 4.0),
                                        Text(restaurant.city ?? "")
                                      ],
                                    ),
                                    SizedBox(height: 4.0),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.star, color: Colors.orange),
                                        SizedBox(width: 4.0),
                                        Text(restaurant.rating.toString() ?? "0.0"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        isFavorited
                            ? IconButton(
                                icon: Icon(Icons.favorite, color: Colors.pinkAccent),
                                onPressed: () => provider.removeFavorite(restaurant.id),
                              )
                            : IconButton(
                                icon: Icon(Icons.favorite_border),
                                onPressed: () => provider.addFavorite(restaurant),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
}
