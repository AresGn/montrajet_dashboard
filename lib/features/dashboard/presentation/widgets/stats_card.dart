import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String trend;
  final bool isPositive;
  final Color? iconColor;

  const StatsCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.trend,
    this.isPositive = true,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Value
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: 4),

            // Trend
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.danger,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPositive ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
