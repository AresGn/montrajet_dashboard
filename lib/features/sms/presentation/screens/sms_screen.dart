import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/navigation_drawer.dart';
import '../../domain/entities/sms_message.dart';
import '../widgets/sms_message_tile.dart';

/// Ecran de gestion des messages SMS
class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  int _currentPage = 1;
  final int _totalPages = 8;
  String _filtreDirection = 'Tous';
  String _filtreDate = 'Aujourd\'hui';
  bool _isRefreshing = false;

  late final List<SmsMessage> _mockMessages;

  @override
  void initState() {
    super.initState();
    _mockMessages = _createMockMessages();
  }

  List<SmsMessage> _createMockMessages() {
    final now = DateTime.now();
    return [
      SmsMessage(
        id: '1',
        direction: SmsDirection.entrant,
        telephone: '+229 97 11 22 33',
        contenu: 'TOKPA Paul Akpakpa Calavi 200F 22h30',
        dateHeure: now.subtract(const Duration(minutes: 15)),
        estLu: true,
        parsedData: const SmsParsedData(
          type: SmsType.demandeTokpa,
          prenom: 'Paul',
          depart: 'Akpakpa',
          arrivee: 'Calavi',
          montant: 200,
          heure: '22:30',
          confiance: 0.95,
        ),
        actionResultat: 'Assigne au trajet AA-1234-BJ',
      ),
      SmsMessage(
        id: '2',
        direction: SmsDirection.sortant,
        telephone: '+229 97 11 22 33',
        contenu: 'Bonjour Paul! Votre place est confirmee sur le Tokpa AA-1234-BJ depart 22h00 Akpakpa vers Calavi. RDV Carrefour Dantokpa. Tel conducteur: 97123456',
        dateHeure: now.subtract(const Duration(minutes: 14)),
        estDelivre: true,
      ),
      SmsMessage(
        id: '3',
        direction: SmsDirection.entrant,
        telephone: '+229 96 44 55 66',
        contenu: 'Dispo Godomey Calavi 6h30 20places 10min 150F',
        dateHeure: now.subtract(const Duration(hours: 1)),
        estLu: true,
        parsedData: const SmsParsedData(
          type: SmsType.disponibiliteConducteur,
          depart: 'Godomey',
          arrivee: 'Calavi',
          heure: '06:30',
          capacite: 20,
          minimum: 10,
          montant: 150,
          confiance: 0.92,
        ),
        actionResultat: 'Trajet AB-5678-BJ cree',
      ),
      SmsMessage(
        id: '4',
        direction: SmsDirection.entrant,
        telephone: '+229 95 88 77 66',
        contenu: 'Je veux aller de Cotonou a Porto-Novo demain matin',
        dateHeure: now.subtract(const Duration(hours: 2)),
        estLu: false,
        parsedData: const SmsParsedData(
          type: SmsType.demandeTokpa,
          depart: 'Cotonou',
          arrivee: 'Porto-Novo',
          confiance: 0.65,
        ),
      ),
      SmsMessage(
        id: '5',
        direction: SmsDirection.sortant,
        telephone: '+229 96 44 55 66',
        contenu: 'Conducteur confirme! Trajet AB-5678-BJ actif. 12 passagers inscrits. Depart prevu 06h30.',
        dateHeure: now.subtract(const Duration(hours: 2, minutes: 30)),
        estDelivre: true,
      ),
      SmsMessage(
        id: '6',
        direction: SmsDirection.entrant,
        telephone: '+229 97 22 33 44',
        contenu: 'Annuler ma reservation pour demain svp',
        dateHeure: now.subtract(const Duration(hours: 3)),
        estLu: true,
        parsedData: const SmsParsedData(
          type: SmsType.annulation,
          confiance: 0.88,
        ),
        actionResultat: 'Reservation annulee - Passager rembourse',
      ),
    ];
  }

  List<SmsMessage> get _filteredMessages {
    var messages = _mockMessages;

    if (_filtreDirection == 'Entrants') {
      messages = messages.where((m) => m.estEntrant).toList();
    } else if (_filtreDirection == 'Sortants') {
      messages = messages.where((m) => m.estSortant).toList();
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sms_outlined),
            SizedBox(width: 8),
            Text('Messages SMS'),
          ],
        ),
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _onRefresh,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          _buildStatsBar(),
          Expanded(
            child: _buildMessagesList(),
          ),
          _buildPagination(),
        ],
      ),
      drawer: const AppNavigationDrawer(),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterDropdown(
              value: _filtreDirection,
              items: ['Tous', 'Entrants', 'Sortants'],
              onChanged: (value) => setState(() => _filtreDirection = value!),
            ),
            const SizedBox(width: 12),
            _buildFilterDropdown(
              value: _filtreDate,
              items: ['Aujourd\'hui', 'Hier', 'Cette semaine', 'Ce mois'],
              onChanged: (value) => setState(() => _filtreDate = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final entrants = _mockMessages.where((m) => m.estEntrant).length;
    final sortants = _mockMessages.where((m) => m.estSortant).length;
    final nonLus = _mockMessages.where((m) => m.estEntrant && !m.estLu).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.call_received, 'Entrants', '$entrants', AppColors.info),
          _buildStatItem(Icons.call_made, 'Sortants', '$sortants', AppColors.success),
          _buildStatItem(Icons.mark_email_unread, 'Non lus', '$nonLus', AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: AppTextStyles.caption,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesList() {
    final messages = _filteredMessages;

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sms_outlined,
              size: 64,
              color: AppColors.grey300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun message',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return SmsMessageTile(
          message: message,
          onTap: () => _showMessageDetails(context, message),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage--)
                : null,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Precedent',
          ),
          const SizedBox(width: 16),
          Text(
            'Page $_currentPage/$_totalPages',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _currentPage < _totalPages
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Suivant',
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);

    // Simuler un chargement
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Messages actualises'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showMessageDetails(BuildContext context, SmsMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                _buildDetailHeader(message),
                const SizedBox(height: 16),
                _buildDetailContent(message),
                if (message.estParse) ...[
                  const SizedBox(height: 16),
                  _buildDetailParsedData(message),
                ],
                const SizedBox(height: 24),
                _buildDetailActions(context, message),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailHeader(SmsMessage message) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: message.estEntrant
                ? AppColors.info.withOpacity(0.1)
                : AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            message.estEntrant ? Icons.call_received : Icons.call_made,
            color: message.estEntrant ? AppColors.info : AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.telephone,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${message.estEntrant ? "Recu" : "Envoye"} a ${message.heureFormatee}',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailContent(SmsMessage message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message.contenu,
        style: AppTextStyles.bodyLarge,
      ),
    );
  }

  Widget _buildDetailParsedData(SmsMessage message) {
    final parsed = message.parsedData!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Analyse IA',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: parsed.type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  parsed.type.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: parsed.type.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Confiance', parsed.confianceFormatee),
          if (parsed.prenom != null)
            _buildDetailRow('Prenom', parsed.prenom!),
          if (parsed.depart != null)
            _buildDetailRow('Depart', parsed.depart!),
          if (parsed.arrivee != null)
            _buildDetailRow('Arrivee', parsed.arrivee!),
          if (parsed.montant != null)
            _buildDetailRow('Montant', '${parsed.montant}F'),
          if (parsed.heure != null)
            _buildDetailRow('Heure', parsed.heure!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.caption,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActions(BuildContext context, SmsMessage message) {
    return Row(
      children: [
        if (message.estEntrant) ...[
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _repondreMessage(message);
              },
              icon: const Icon(Icons.reply),
              label: const Text('Repondre'),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              if (message.trajetAssocieId != null) {
                _voirTrajet(message.trajetAssocieId!);
              }
            },
            icon: const Icon(Icons.directions_bus),
            label: const Text('Voir trajet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _repondreMessage(SmsMessage message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Repondre a ${message.telephone}')),
    );
  }

  void _voirTrajet(String trajetId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voir trajet $trajetId')),
    );
  }
}
