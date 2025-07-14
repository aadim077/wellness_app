import 'package:flutter/material.dart';
import 'package:wellness/core/route_config/routes_name.dart';
import 'package:wellness/dashboard_screen.dart';
import 'package:wellness/login_screen.dart';

// Add this import if not already present
import 'package:wellness/core/route_config/routes_name.dart';
// Assuming RoutesName is defined here

class RouteConfig {
  RouteConfig._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String? screenName = settings.name;
    final dynamic arg = settings.arguments;

    switch (screenName) {
      case RoutesName.dashboardScreen:
        return MaterialPageRoute(
          builder: (_) =>
              DashboardScreen(dashboardViewModel: null,),
        );

      case RoutesName.defaultScreen:
        return MaterialPageRoute(
            builder: (_) => const LoginScreen());

      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
