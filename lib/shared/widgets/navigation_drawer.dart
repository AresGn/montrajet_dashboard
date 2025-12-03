import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/trajets/presentation/screens/trajets_list_screen.dart';
import '../../features/sms/presentation/screens/sms_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.directions_bus_rounded,
                  size: 48,
                  color: AppColors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  'MonTrajet',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Dashboard Admin',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Tableau de bord'),
            selected: ModalRoute.of(context)?.settings.name == '/' ||
                ModalRoute.of(context)?.settings.name == '/dashboard',
            selectedTileColor: AppColors.primary.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardHomeScreen(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bus_outlined),
            title: const Text('Trajets'),
            selected: ModalRoute.of(context)?.settings.name == '/trajets',
            selectedTileColor: AppColors.primary.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/trajets') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TrajetsListScreen(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.sms_outlined),
            title: const Text('Messages SMS'),
            selected: ModalRoute.of(context)?.settings.name == '/sms',
            selectedTileColor: AppColors.primary.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/sms') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SmsScreen(),
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car_outlined),
            title: const Text('Covoiturages'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to covoiturage screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Logout
            },
          ),
        ],
      ),
    );
  }
}
