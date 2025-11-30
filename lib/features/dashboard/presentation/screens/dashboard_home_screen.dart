import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/stats_card.dart';
import '../widgets/realtime_alerts_list.dart';
import '../widgets/weekly_chart.dart';

class DashboardHomeScreen extends ConsumerStatefulWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardHomeScreen> createState() =>
      _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends ConsumerState<DashboardHomeScreen> {
  // Mock data - will be replaced with real data from providers
  final List<RealtimeAlert> _mockAlerts = [
    RealtimeAlert(
      message: 'SMS reçu - Paul: "Akpakpa Calavi 200F 22h30"',
      type: AlertType.success,
      timestamp: DateTime.now(),
    ),
    RealtimeAlert(
      message: 'Trajet 21h00 - Seuil non atteint (8/10 passagers)',
      type: AlertType.warning,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    RealtimeAlert(
      message: 'Nouveau conducteur inscrit - Plaque AA-1234-BJ',
      type: AlertType.info,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  final List<double> _mockWeeklyData = [120, 145, 160, 135, 170, 155, 140];
  final List<String> _mockWeeklyLabels = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
    'Dim'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy'); // Suppression de la locale fr_FR

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.directions_bus_rounded, size: 28),
            const SizedBox(width: 8),
            const Text('MonTrajet'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.account_circle, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Admin',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date
              Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATISTIQUES DU JOUR',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dateFormat.format(now),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  final crossAxisCount = isWide ? 4 : 2;

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: isWide ? 1.2 : 1.3,
                    children: [
                      StatsCard(
                        icon: Icons.sms_outlined,
                        title: 'SMS Reçus',
                        value: '156',
                        trend: '+12%',
                        isPositive: true,
                        iconColor: AppColors.info,
                      ),
                      StatsCard(
                        icon: Icons.people_outline,
                        title: 'Passagers Actifs',
                        value: '89',
                        trend: '+8%',
                        isPositive: true,
                        iconColor: AppColors.success,
                      ),
                      StatsCard(
                        icon: Icons.directions_bus_outlined,
                        title: 'Trajets Confirmés',
                        value: '12',
                        trend: '+3',
                        isPositive: true,
                        iconColor: AppColors.primary,
                      ),
                      StatsCard(
                        icon: Icons.payments_outlined,
                        title: 'Recette Totale',
                        value: '18,400F',
                        trend: '+15%',
                        isPositive: true,
                        iconColor: AppColors.warning,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Realtime Alerts
              RealtimeAlertsList(alerts: _mockAlerts),
              const SizedBox(height: 24),

              // Weekly Chart
              WeeklyChart(
                weeklyData: _mockWeeklyData,
                labels: _mockWeeklyLabels,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Refresh action
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Rafraîchir'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Export action
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Exporter'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Settings action
                      },
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Paramètres'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
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
            selected: true,
            selectedTileColor: AppColors.primary.withOpacity(0.1),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bus_outlined),
            title: const Text('Trajets'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to trajets screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.sms_outlined),
            title: const Text('Messages SMS'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to SMS screen
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
