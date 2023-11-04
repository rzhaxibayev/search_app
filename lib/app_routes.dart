import 'package:flutter/material.dart';
import 'package:search_app/address.dart';
import 'package:search_app/details_screen.dart';
import 'package:search_app/search_screen.dart';

class AppRoutes {
  static Route<Object?> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case '/':
      case SearchScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const SearchScreen();
          },
          settings: settings,
        );
      case DetailsScreen.routeName:
        final address = settings.arguments as Address;
        return MaterialPageRoute(
          builder: (context) {
            return DetailsScreen(address: address);
          },
          settings: settings,
        );
    }

    throw Exception('No such route found');
  }
}
