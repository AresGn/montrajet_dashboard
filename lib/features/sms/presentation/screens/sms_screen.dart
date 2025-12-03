import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/navigation_drawer.dart';
import '../../domain/entities/sms_message.dart';
import '../widgets/sms_message_tile.dart';

/// Ecran moderne de gestion des messages SMS
class SmsScreen extends StatefulWidget {
  const SmsScreen({super.key});

  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;
  final int _totalPages = 8;
  bool _isRefreshing = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late final List<SmsMessage> _mockMessages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _mockMessages = _createMockMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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

  List<SmsMessage> _getFilteredMessages(int tabIndex) {
    var messages = _mockMessages;

    // Filtre par onglet
    if (tabIndex == 1) {
      messages = messages.where((m) => m.estEntrant).toList();
    } else if (tabIndex == 2) {
      messages = messages.where((m) => m.estSortant).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      messages = messages.where((m) =>
          m.telephone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.contenu.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndStats(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesList(0),
                _buildMessagesList(1),
                _buildMessagesList(2),
              ],
            ),
          ),
          _buildPagination(),
        ],
      ),
      drawer: const AppNavigationDrawer(),
      floatingActionButton: _buildFAB(isSmallScreen),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.grey800,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sms_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages SMS',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_mockMessages.length} messages',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          onPressed: _isRefreshing ? null : _onRefresh,
          tooltip: 'Actualiser',
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: _showFilterBottomSheet,
          tooltip: 'Filtres',
        ),
      ],
    );
  }

  Widget _buildSearchAndStats() {
    final entrants = _mockMessages.where((m) => m.estEntrant).length;
    final sortants = _mockMessages.where((m) => m.estSortant).length;
    final nonLus = _mockMessages.where((m) => m.estEntrant && !m.estLu).length;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Barre de recherche moderne
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher par numero ou contenu...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey400,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.grey400,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats cards - Responsive
              if (constraints.maxWidth < 500)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.call_received_rounded,
                            label: 'Entrants',
                            value: '$entrants',
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.call_made_rounded,
                            label: 'Sortants',
                            value: '$sortants',
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _buildStatCard(
                        icon: Icons.mark_email_unread_rounded,
                        label: 'Non lus',
                        value: '$nonLus',
                        color: nonLus > 0 ? AppColors.warning : AppColors.grey400,
                        highlighted: nonLus > 0,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.call_received_rounded,
                        label: 'Entrants',
                        value: '$entrants',
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.call_made_rounded,
                        label: 'Sortants',
                        value: '$sortants',
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.mark_email_unread_rounded,
                        label: 'Non lus',
                        value: '$nonLus',
                        color: nonLus > 0 ? AppColors.warning : AppColors.grey400,
                        highlighted: nonLus > 0,
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool highlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlighted ? color.withOpacity(0.1) : AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? color.withOpacity(0.3) : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.grey500,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.all_inbox_rounded, size: 18),
                const SizedBox(width: 6),
                const Text('Tous'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call_received_rounded, size: 18),
                const SizedBox(width: 6),
                const Text('Entrants'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call_made_rounded, size: 18),
                const SizedBox(width: 6),
                const Text('Sortants'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(int tabIndex) {
    final messages = _getFilteredMessages(tabIndex);

    if (messages.isEmpty) {
      return _buildEmptyState(tabIndex);
    }

    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 80),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return SmsMessageTile(
            message: message,
            onTap: () => _showMessageDetails(context, message),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(int tabIndex) {
    String title;
    String subtitle;
    IconData icon;

    switch (tabIndex) {
      case 1:
        title = 'Aucun message entrant';
        subtitle = 'Les SMS recus apparaitront ici';
        icon = Icons.call_received_rounded;
        break;
      case 2:
        title = 'Aucun message sortant';
        subtitle = 'Les SMS envoyes apparaitront ici';
        icon = Icons.call_made_rounded;
        break;
      default:
        title = 'Aucun message';
        subtitle = 'Les SMS apparaitront ici';
        icon = Icons.sms_outlined;
    }

    if (_searchQuery.isNotEmpty) {
      title = 'Aucun resultat';
      subtitle = 'Aucun message ne correspond a "$_searchQuery"';
      icon = Icons.search_off_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.grey600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPaginationButton(
            icon: Icons.chevron_left_rounded,
            onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Page $_currentPage / $_totalPages',
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          _buildPaginationButton(
            icon: Icons.chevron_right_rounded,
            onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Material(
      color: onPressed != null ? AppColors.primary : AppColors.grey200,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: onPressed != null ? AppColors.white : AppColors.grey400,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(bool isSmallScreen) {
    return FloatingActionButton.extended(
      onPressed: _showComposeDialog,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 4,
      icon: const Icon(Icons.edit_rounded),
      label: Text(isSmallScreen ? 'Nouveau' : 'Nouveau SMS'),
      heroTag: 'sms_fab',
      tooltip: 'Nouveau message',
    );
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.white),
              const SizedBox(width: 12),
              const Text('Messages actualises'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Filtres',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('Aujourd\'hui', true),
            _buildFilterOption('Hier', false),
            _buildFilterOption('Cette semaine', false),
            _buildFilterOption('Ce mois', false),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Appliquer'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, bool selected) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: selected ? AppColors.primary : AppColors.grey400,
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () {},
    );
  }

  void _showComposeDialog() {
    String? selectedContact;
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Nouveau message',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Sélectionner un contact',
                    prefixIcon: const Icon(Icons.contacts_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: selectedContact,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Sélectionnez un contact'),
                    ),
                    ..._getContactsList().map((contact) {
                      return DropdownMenuItem<String>(
                        value: contact['telephone'],
                        child: Text(
                          '${contact['nom']} - ${contact['telephone']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedContact = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    prefixIcon: const Icon(Icons.message_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: selectedContact != null && messageController.text.isNotEmpty
                        ? () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'SMS envoyé à $selectedContact',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Envoyer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getContactsList() {
    return [
      {'nom': 'Jean Koffi', 'telephone': '+229 97 12 34 56'},
      {'nom': 'Marie Houessou', 'telephone': '+229 96 78 90 12'},
      {'nom': 'Thomas Dossou', 'telephone': '+229 95 44 55 66'},
      {'nom': 'Paul Akplogan', 'telephone': '+229 97 11 22 33'},
      {'nom': 'Sophie Yao', 'telephone': '+229 97 33 44 55'},
      {'nom': 'David Soglo', 'telephone': '+229 96 44 55 66'},
      {'nom': 'Emma Kindé', 'telephone': '+229 97 55 66 77'},
      {'nom': 'Luc Allagbé', 'telephone': '+229 96 66 77 88'},
      {'nom': 'Lea Aké', 'telephone': '+229 97 77 88 99'},
      {'nom': 'Hugo Hounsou', 'telephone': '+229 96 88 99 00'},
    ];
  }

  void _showMessageDetails(BuildContext context, SmsMessage message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailHeader(message),
                  const SizedBox(height: 20),
                  _buildDetailContent(message),
                  if (message.estParse) ...[
                    const SizedBox(height: 20),
                    _buildDetailParsedData(message),
                  ],
                  const SizedBox(height: 24),
                  _buildDetailActions(context, message),
                  const SizedBox(height: 20),
                ],
              ),
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: message.estEntrant
                  ? [AppColors.info, AppColors.info.withOpacity(0.7)]
                  : [AppColors.success, AppColors.success.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (message.estEntrant ? AppColors.info : AppColors.success)
                    .withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            message.estEntrant ? Icons.call_received_rounded : Icons.call_made_rounded,
            color: AppColors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.telephone,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    message.estEntrant ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                    size: 14,
                    color: message.estEntrant ? AppColors.info : AppColors.success,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${message.estEntrant ? "Recu" : "Envoye"} a ${message.heureFormatee}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.message_rounded,
                size: 18,
                color: AppColors.grey400,
              ),
              const SizedBox(width: 8),
              Text(
                'Contenu du message',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message.contenu,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailParsedData(SmsMessage message) {
    final parsed = message.parsedData!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Analyse IA',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: parsed.type.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  parsed.type.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: parsed.type.color,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (parsed.prenom != null) _buildDetailRow('Prenom', parsed.prenom!),
          if (parsed.depart != null) _buildDetailRow('Depart', parsed.depart!),
          if (parsed.arrivee != null) _buildDetailRow('Arrivee', parsed.arrivee!),
          if (parsed.montant != null) _buildDetailRow('Montant', '${parsed.montant}F'),
          if (parsed.heure != null) _buildDetailRow('Heure', parsed.heure!),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Confiance:', style: AppTextStyles.bodySmall),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: parsed.confiance,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      parsed.confiance >= 0.9 ? AppColors.success : AppColors.warning,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                parsed.confianceFormatee,
                style: AppTextStyles.labelMedium.copyWith(
                  color: parsed.confiance >= 0.9 ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActions(BuildContext context, SmsMessage message) {
    return Column(
      children: [
        if (message.estEntrant)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Repondre a ${message.telephone}')),
                );
              },
              icon: const Icon(Icons.reply_rounded),
              label: const Text('Repondre'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.directions_bus_rounded),
            label: const Text('Voir le trajet associe'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
