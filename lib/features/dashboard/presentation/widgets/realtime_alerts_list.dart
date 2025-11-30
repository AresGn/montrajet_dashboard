import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

enum AlertType {
  success,
  warning,
  info,
}

class RealtimeAlert {
  final String message;
  final AlertType type;
  final DateTime timestamp;

  RealtimeAlert({
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

class RealtimeAlertsList extends StatelessWidget {
  final List<RealtimeAlert> alerts;

  const RealtimeAlertsList({
    Key? key,
    required this.alerts,
  }) : super(key: key);

  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.success:
        return AppColors.success;
      case AlertType.warning:
        return AppColors.warning;
      case AlertType.info:
        return AppColors.info;
    }
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'ALERTES TEMPS RÉEL',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (alerts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'Aucune alerte pour le moment',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),
              )
            else
              ...alerts.map((alert) => _buildAlertItem(alert)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(RealtimeAlert alert) {
    final color = _getAlertColor(alert.type);
    final icon = _getAlertIcon(alert.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
