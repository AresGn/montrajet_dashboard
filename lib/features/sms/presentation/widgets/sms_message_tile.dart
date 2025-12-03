import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/sms_message.dart';

/// Widget affichant un message SMS dans la liste
class SmsMessageTile extends StatelessWidget {
  final SmsMessage message;
  final VoidCallback? onTap;

  const SmsMessageTile({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            _buildHeader(),
            const Divider(height: 1),
            _buildContent(),
            if (message.estParse) ...[
              const Divider(height: 1),
              _buildParsedData(),
            ],
            if (message.actionResultat != null) ...[
              const Divider(height: 1),
              _buildActionResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: message.estEntrant
                  ? AppColors.info.withOpacity(0.1)
                  : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  message.estEntrant
                      ? Icons.call_received
                      : Icons.call_made,
                  size: 14,
                  color: message.estEntrant
                      ? AppColors.info
                      : AppColors.success,
                ),
                const SizedBox(width: 4),
                Text(
                  message.estEntrant ? 'ENTRANT' : 'SORTANT',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: message.estEntrant
                        ? AppColors.info
                        : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message.heureFormatee,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message.telephone,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (message.estSortant) ...[
            if (message.estDelivre)
              const Icon(Icons.done_all, size: 16, color: AppColors.success)
            else
              const Icon(Icons.done, size: 16, color: AppColors.grey400),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        '"${message.contenu}"',
        style: AppTextStyles.bodyMedium.copyWith(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildParsedData() {
    final parsed = message.parsedData!;
    return Container(
      padding: const EdgeInsets.all(12),
      color: AppColors.grey50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'Parse par LLM:',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildParsedItem('Type', parsed.type.label, parsed.type.color),
              if (parsed.prenom != null)
                _buildParsedItem('Prenom', parsed.prenom!),
              if (parsed.depart != null)
                _buildParsedItem('Depart', parsed.depart!),
              if (parsed.arrivee != null)
                _buildParsedItem('Arrivee', parsed.arrivee!),
              if (parsed.montant != null)
                _buildParsedItem('Montant', '${parsed.montant}F'),
              if (parsed.heure != null)
                _buildParsedItem('Heure', parsed.heure!),
              if (parsed.capacite != null)
                _buildParsedItem('Capacite', '${parsed.capacite}'),
              if (parsed.minimum != null)
                _buildParsedItem('Minimum', '${parsed.minimum}'),
              _buildParsedItem(
                'Confiance',
                parsed.confianceFormatee,
                parsed.confiance >= 0.9
                    ? AppColors.success
                    : parsed.confiance >= 0.7
                        ? AppColors.warning
                        : AppColors.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParsedItem(String label, String value, [Color? valueColor]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? AppColors.grey800,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionResult() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.gps_fixed, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Action: ',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.grey600,
            ),
          ),
          Expanded(
            child: Text(
              message.actionResultat!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
