class DetailResult {
  DetailResult({
    this.error,
    this.message,
    this.restaurant,
  });

  bool error;
  String message;
  RestaurantDetails restaurant;

  factory DetailResult.fromJson(Map<String, dynamic> json) => DetailResult(
    error: json["error"],
    message: json["message"],
    restaurant: RestaurantDetails.fromJson(json["restaurant"]),
  );
}

class RestaurantDetails {
  RestaurantDetails({
    this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  String id;
  String name;
  String description;
  String city;
  String address;
  String pictureId;
  List<String> categories;
  Menus menus;
  double rating;
  List<CustomerReview> customerReviews;

  RestaurantDetails.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    description = json["description"];
    city = json["city"];
    address = json["address"];
    pictureId = json["pictureId"];
    if (json["categories"] != null) {
      categories = [];
      json["categories"].forEach((x) => categories.add(x["name"]));
    }
    menus = Menus.fromJson(json["menus"]);
    rating = json["rating"].toDouble();
    customerReviews = List<CustomerReview>.from(json["customerReviews"].map((x) => CustomerReview.fromJson(x)));
  }
}

class CustomerReview {
  CustomerReview({
    this.name,
    this.review,
    this.date,
  });

  String name;
  String review;
  String date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );
}

class Menus {
  Menus({
    this.foods,
    this.drinks,
  });

  List<String> foods;
  List<String> drinks;

  Menus.fromJson(Map<String, dynamic> json) {
    if (json["foods"] != null) {
      foods = [];
      json["foods"].forEach((x) => foods.add(x["name"]));
    }
    if (json["drinks"] != null) {
      drinks = [];
      json["drinks"].forEach((x) => drinks.add(x["name"]));
    }
  }
}
