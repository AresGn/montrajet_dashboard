import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/sms_message.dart';

/// Widget moderne affichant un message SMS
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: message.estEntrant
                ? (message.estLu ? AppColors.grey200 : AppColors.info.withOpacity(0.3))
                : AppColors.grey200,
            width: message.estEntrant && !message.estLu ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec indicateur de direction
              _buildHeader(),

              // Contenu du message
              _buildMessageContent(),

              // Section parsing IA (si disponible)
              if (message.estParse) _buildAISection(),

              // Footer avec action
              if (message.actionResultat != null) _buildActionFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: message.estEntrant
              ? [AppColors.info.withOpacity(0.08), AppColors.info.withOpacity(0.02)]
              : [AppColors.success.withOpacity(0.08), AppColors.success.withOpacity(0.02)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Icone direction avec animation
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: message.estEntrant
                    ? [AppColors.info, AppColors.info.withOpacity(0.7)]
                    : [AppColors.success, AppColors.success.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: (message.estEntrant ? AppColors.info : AppColors.success)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              message.estEntrant ? Icons.call_received_rounded : Icons.call_made_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),

          // Infos telephone et heure
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.telephone,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey800,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: AppColors.grey400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      message.heureFormatee,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Badge non lu ou statut envoi
          if (message.estEntrant && !message.estLu)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.info,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Nouveau',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            )
          else if (message.estSortant)
            Row(
              children: [
                Icon(
                  message.estDelivre ? Icons.done_all_rounded : Icons.done_rounded,
                  size: 18,
                  color: message.estDelivre ? AppColors.success : AppColors.grey400,
                ),
                const SizedBox(width: 4),
                Text(
                  message.estDelivre ? 'Delivre' : 'Envoye',
                  style: AppTextStyles.caption.copyWith(
                    color: message.estDelivre ? AppColors.success : AppColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 20,
                  color: AppColors.grey300,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message.contenu,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection() {
    final parsed = message.parsedData!;
    final confianceColor = parsed.confiance >= 0.9
        ? AppColors.success
        : parsed.confiance >= 0.7
            ? AppColors.warning
            : AppColors.danger;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header IA
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Analyse IA',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              // Badge type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: parsed.type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: parsed.type.color.withOpacity(0.3)),
                ),
                child: Text(
                  parsed.type.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: parsed.type.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Données parsées en chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (parsed.prenom != null)
                _buildDataChip(Icons.person_outline_rounded, parsed.prenom!),
              if (parsed.depart != null)
                _buildDataChip(Icons.trip_origin_rounded, parsed.depart!, isDepart: true),
              if (parsed.arrivee != null)
                _buildDataChip(Icons.place_rounded, parsed.arrivee!, isArrivee: true),
              if (parsed.montant != null)
                _buildDataChip(Icons.payments_outlined, '${parsed.montant}F'),
              if (parsed.heure != null)
                _buildDataChip(Icons.schedule_rounded, parsed.heure!),
              if (parsed.capacite != null)
                _buildDataChip(Icons.airline_seat_recline_normal_rounded, '${parsed.capacite} places'),
            ],
          ),

          const SizedBox(height: 10),

          // Barre de confiance
          Row(
            children: [
              Text(
                'Confiance:',
                style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: parsed.confiance,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(confianceColor),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                parsed.confianceFormatee,
                style: AppTextStyles.labelSmall.copyWith(
                  color: confianceColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataChip(IconData icon, String text, {bool isDepart = false, bool isArrivee = false}) {
    Color chipColor = AppColors.grey600;
    if (isDepart) chipColor = AppColors.warning;
    if (isArrivee) chipColor = AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        border: Border(
          top: BorderSide(color: AppColors.success.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 14,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message.actionResultat!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.success.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
