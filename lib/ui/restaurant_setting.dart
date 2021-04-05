import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/provider/preference_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';

class RestaurantSettingPage extends StatelessWidget {
  Widget _buildList(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, provider, _) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: provider.isDarkTheme,
                  onChanged: (value) => provider.toggleDarkMode(value)
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: Text('Daily Restaurant'),
                subtitle: Text('Refreshing restaurants at 11.00 AM'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                        value: provider.isNotifActive,
                        onChanged: (value) async {
                          if (Platform.isIOS) {
                            showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) =>
                                  CupertinoAlertDialog(
                                    title: Text('Coming Soon!'),
                                    content: Text('This feature will be coming soon!'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text('OK'),
                                        onPressed: () => Navigation.back(),
                                      ),
                                    ],
                                  ),
                            );
                          } else {
                            scheduled.scheduledNews(value);
                            provider.toggleNotification(value);
                          }
                        });
                  },
                )
              ),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _buildList(context),
    );
  }
}