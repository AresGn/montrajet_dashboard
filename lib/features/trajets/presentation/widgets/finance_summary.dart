import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Widget affichant le resume financier d'un trajet
class FinanceSummary extends StatelessWidget {
  final String recetteTotale;
  final String commission;
  final int nombrePassagers;
  final String montantConducteur;

  const FinanceSummary({
    super.key,
    required this.recetteTotale,
    required this.commission,
    required this.nombrePassagers,
    required this.montantConducteur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'FINANCES',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grey600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFinanceRow(
                  'Recette totale',
                  recetteTotale,
                  valueColor: AppColors.grey900,
                  isBold: true,
                ),
                const SizedBox(height: 12),
                _buildFinanceRow(
                  'Commission Tokpa',
                  '$commission (50F x $nombrePassagers passagers)',
                  valueColor: AppColors.warning,
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _buildFinanceRow(
                  'Conducteur recoit',
                  montantConducteur,
                  valueColor: AppColors.success,
                  isBold: true,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceRow(
    String label,
    String value, {
    Color valueColor = AppColors.grey900,
    bool isBold = false,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: isHighlighted
          ? const EdgeInsets.all(12)
          : EdgeInsets.zero,
      decoration: isHighlighted
          ? BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  )
                : AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
