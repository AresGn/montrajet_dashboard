import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/trajets/presentation/screens/trajets_list_screen.dart';
import '../../features/sms/presentation/screens/sms_screen.dart';

class AppRouter {
  static Route<MaterialPageRoute> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const DashboardHomeScreen(),
        );
      case '/trajets':
        return MaterialPageRoute(
          builder: (_) => const TrajetsListScreen(),
        );
      case '/sms':
        return MaterialPageRoute(
          builder: (_) => const SmsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const DashboardHomeScreen(),
        );
    }
  }
}
