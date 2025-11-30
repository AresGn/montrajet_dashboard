import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TrajetCard extends StatelessWidget {
  final String plaque;
  final String depart;
  final String arrivee;
  final String heure;
  final String conducteurNom;
  final String conducteurTel;
  final int passagersActuels;
  final int capaciteTotale;
  final double pourcentageRemplissage;
  final String montantRecette;
  final String statut;
  final Color statutColor;
  final VoidCallback? onTap;
  final VoidCallback? onModifier;
  final VoidCallback? onVoirDetails;
  final VoidCallback? onSMSListe;
  final VoidCallback? onAnnuler;

  const TrajetCard({
    super.key,
    required this.plaque,
    required this.depart,
    required this.arrivee,
    required this.heure,
    required this.conducteurNom,
    required this.conducteurTel,
    required this.passagersActuels,
    required this.capaciteTotale,
    required this.pourcentageRemplissage,
    required this.montantRecette,
    required this.statut,
    required this.statutColor,
    this.onTap,
    this.onModifier,
    this.onVoirDetails,
    this.onSMSListe,
    this.onAnnuler,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du trajet
            Row(
              children: [
                Icon(
                  Icons.directions_bus_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$plaque | $depart → $arrivee | $heure',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Informations conducteur
            Text(
              'Conducteur: $conducteurNom ($conducteurTel)',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Barre de progression passagers
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '👥 Passagers: $passagersActuels/$capaciteTotale',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(pourcentageRemplissage * 100).toInt()}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statutColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: pourcentageRemplissage,
                  backgroundColor: AppColors.grey200,
                  valueColor: AlwaysStoppedAnimation<Color>(statutColor),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recette
            Text(
              '💰 Recette: $montantRecette',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Statut
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: statutColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statutColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: statutColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '📍 Statut: $statut',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: statutColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Boutons d'action
            if (isMobile)
              _buildMobileButtons(context)
            else
              _buildDesktopButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (onVoirDetails != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onVoirDetails,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Voir détails'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            if (onVoirDetails != null && (onModifier != null || onSMSListe != null))
              const SizedBox(width: 8),
            if (onModifier != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onModifier,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Modifier'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            if ((onModifier != null || onVoirDetails != null) && onSMSListe != null)
              const SizedBox(width: 8),
            if (onSMSListe != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSMSListe,
                  icon: const Icon(Icons.sms_outlined, size: 18),
                  label: const Text('Liste SMS'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
          ],
        ),
        if (onAnnuler != null) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAnnuler,
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Annuler et réaffecter'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                foregroundColor: AppColors.danger,
                side: BorderSide(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopButtons(BuildContext context) {
    return Row(
      children: [
        if (onVoirDetails != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onVoirDetails,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Voir détails'),
            ),
          ),
        if (onVoirDetails != null && (onModifier != null || onSMSListe != null))
          const SizedBox(width: 12),
        if (onModifier != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onModifier,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Modifier'),
            ),
          ),
        if (onModifier != null && onSMSListe != null)
          const SizedBox(width: 12),
        if (onSMSListe != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onSMSListe,
              icon: const Icon(Icons.sms_outlined),
              label: const Text('Liste passagers'),
            ),
          ),
        if (onAnnuler != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onAnnuler,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Annuler et réaffecter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: BorderSide(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
