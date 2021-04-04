import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/ui/restaurant_detail.dart';
import 'package:restaurant_app/ui/restaurant_favorite.dart';
import 'package:restaurant_app/ui/restaurant_list.dart';
import 'package:restaurant_app/ui/restaurant_search.dart';
import 'package:restaurant_app/ui/restaurant_setting.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/restaurant_list';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  int _bottomNavIndex = 0;

  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_sharp),
      label: 'Restaurants'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorite'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings'
    ),
  ];

  List<Widget> _listWidget = [
    RestaurantListPage(),
    RestaurantSearchPage(),
    RestaurantFavoritePage(),
    RestaurantSettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    port.listen((_) async => await _service.someTask());
    _notificationHelper.configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (selected) => setState(() => _bottomNavIndex = selected),
      ),
    );
  }
}