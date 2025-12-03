import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/trajet.dart';
import '../widgets/passager_list_item.dart';
import '../widgets/finance_summary.dart';

/// Écran de détails d'un trajet
class TrajetDetailScreen extends StatelessWidget {
  final Trajet trajet;

  const TrajetDetailScreen({
    super.key,
    required this.trajet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Trajet ${trajet.plaque}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _onModifier(context),
            tooltip: 'Modifier',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConducteurSection(),
            const SizedBox(height: 16),
            _buildDetailsTrajetSection(),
            const SizedBox(height: 16),
            _buildPassagersSection(context),
            const SizedBox(height: 16),
            FinanceSummary(
              recetteTotale: trajet.recetteFormatee,
              commission: trajet.commissionFormatee,
              nombrePassagers: trajet.passagersActuels,
              montantConducteur: trajet.montantConducteurFormate,
            ),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildConducteurSection() {
    return _buildSection(
      icon: Icons.directions_bus_outlined,
      title: 'INFORMATIONS CONDUCTEUR',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Nom', trajet.conducteurNom),
          _buildInfoRow('Telephone', trajet.conducteurTel),
          _buildInfoRow('Plaque', trajet.plaque),
          _buildInfoRow('Capacite', '${trajet.capaciteTotale} places'),
        ],
      ),
    );
  }

  Widget _buildDetailsTrajetSection() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return _buildSection(
      icon: Icons.location_on_outlined,
      title: 'DETAILS TRAJET',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Depart', trajet.pointDepart.isNotEmpty
              ? '${trajet.depart} (${trajet.pointDepart})'
              : trajet.depart),
          _buildInfoRow('Arrivee', trajet.pointArrivee.isNotEmpty
              ? '${trajet.arrivee} (${trajet.pointArrivee})'
              : trajet.arrivee),
          _buildInfoRow('Heure', trajet.heure),
          _buildInfoRow('Date', dateFormat.format(trajet.date)),
          _buildInfoRow('Minimum requis', '${trajet.seuilMinimum} passagers'),
          if (trajet.prixZones.isNotEmpty)
            _buildInfoRow(
              'Prix zones',
              trajet.prixZones.entries
                  .map((e) => '${e.key}=${e.value}F')
                  .join(' | '),
            ),
        ],
      ),
    );
  }

  Widget _buildPassagersSection(BuildContext context) {
    return _buildSection(
      icon: Icons.people_outline,
      title: 'PASSAGERS INSCRITS (${trajet.passagersActuels}/${trajet.capaciteTotale})',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusBadge(),
        ],
      ),
      child: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: trajet.pourcentageRemplissage,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              trajet.pourcentageRemplissage >= 1.0
                  ? AppColors.success
                  : trajet.pourcentageRemplissage >= 0.5
                      ? AppColors.warning
                      : AppColors.danger,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(trajet.pourcentageRemplissage * 100).toInt()}% rempli',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),

          // Liste des passagers
          if (trajet.passagers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Aucun passager inscrit',
                style: AppTextStyles.bodyMedium,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trajet.passagers.length > 5
                  ? 5
                  : trajet.passagers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final passager = trajet.passagers[index];
                return PassagerListItem(
                  index: index + 1,
                  passager: passager,
                );
              },
            ),

          if (trajet.passagers.length > 5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '... (${trajet.passagers.length - 5} autres)',
                style: AppTextStyles.caption.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Boutons d'action pour les passagers
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _onExporterListe(context),
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Exporter liste'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _onEnvoyerSMSGroupe(context),
                  icon: const Icon(Icons.sms_outlined, size: 18),
                  label: const Text('SMS groupe'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: trajet.statut.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: trajet.statut.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: trajet.statut.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            trajet.statut.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: trajet.statut.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: trajet.statut != TrajetStatut.confirme
                ? () => _onConfirmer(context)
                : null,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Confirmer trajet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _onAnnuler(context),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Annuler'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
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
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.grey600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _onModifier(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modifier trajet - A implementer')),
    );
  }

  void _onConfirmer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le trajet'),
        content: Text(
          'Confirmer le trajet ${trajet.plaque} ?\n'
          'Passagers: ${trajet.passagersActuels}/${trajet.capaciteTotale}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trajet ${trajet.plaque} confirme'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _onAnnuler(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler le trajet'),
        content: Text(
          'Etes-vous sur de vouloir annuler le trajet ${trajet.plaque} ?\n'
          'Les ${trajet.passagersActuels} passagers seront notifies.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trajet ${trajet.plaque} annule'),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  void _onExporterListe(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export liste passagers - A implementer')),
    );
  }

  void _onEnvoyerSMSGroupe(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Envoi SMS groupe a ${trajet.passagersActuels} passagers - A implementer',
        ),
      ),
    );
  }
}
