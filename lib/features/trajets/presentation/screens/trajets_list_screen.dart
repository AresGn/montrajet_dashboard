import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/navigation_drawer.dart';
import '../../domain/entities/trajet.dart';
import '../../domain/entities/passager.dart';
import '../widgets/trajet_card.dart';
import 'trajet_detail_screen.dart';

class TrajetsListScreen extends StatefulWidget {
  const TrajetsListScreen({super.key});

  @override
  State<TrajetsListScreen> createState() => _TrajetsListScreenState();
}

class _TrajetsListScreenState extends State<TrajetsListScreen> {
  int _currentPage = 1;
  final int _totalPages = 4;
  String _filtreActuel = 'Tous';
  final TextEditingController _searchController = TextEditingController();
  bool _showMap = false;

  // Donnees mock pour la demonstration
  late final List<Trajet> _mockTrajets;

  @override
  void initState() {
    super.initState();
    _mockTrajets = _createMockTrajets();
  }

  List<Trajet> _createMockTrajets() {
    return [
      Trajet(
        id: '1',
        plaque: 'AA-1234-BJ',
        depart: 'Akpakpa',
        arrivee: 'Calavi',
        pointDepart: 'Carrefour Dantokpa',
        pointArrivee: 'Carrefour Universite',
        heure: '22:00',
        date: DateTime.now(),
        conducteurNom: 'Jean Koffi',
        conducteurTel: '+229 97 12 34 56',
        passagersActuels: 12,
        capaciteTotale: 20,
        seuilMinimum: 10,
        recetteTotale: 2400,
        statut: TrajetStatut.enAttente,
        positionDepart: const LatLng(6.3654, 2.4183),
        positionArrivee: const LatLng(6.4167, 2.2833),
        prixZones: {'Z1': 150, 'Z2': 200, 'Z3': 250},
        passagers: [
          const Passager(id: '1', prenom: 'Paul', telephone: '97001122', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '2', prenom: 'Marie', telephone: '96112233', depart: 'Akpakpa', arrivee: 'PK14', montant: 150),
          const Passager(id: '3', prenom: 'Jean', telephone: '95223344', depart: 'Dantokpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '4', prenom: 'Sophie', telephone: '97334455', depart: 'Godomey', arrivee: 'Calavi', montant: 100),
          const Passager(id: '5', prenom: 'David', telephone: '96445566', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '6', prenom: 'Emma', telephone: '97556677', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '7', prenom: 'Lucas', telephone: '96667788', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '8', prenom: 'Lea', telephone: '97778899', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '9', prenom: 'Hugo', telephone: '96889900', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '10', prenom: 'Chloe', telephone: '97990011', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '11', prenom: 'Nathan', telephone: '96001122', depart: 'Akpakpa', arrivee: 'Calavi', montant: 200),
          const Passager(id: '12', prenom: 'Ines', telephone: '97112233', depart: 'Akpakpa', arrivee: 'Calavi', montant: 150),
        ],
      ),
      Trajet(
        id: '2',
        plaque: 'AB-5678-BJ',
        depart: 'Cotonou',
        arrivee: 'Godomey',
        heure: '06:30',
        date: DateTime.now(),
        conducteurNom: 'Marie Houessou',
        conducteurTel: '+229 96 78 90 12',
        passagersActuels: 18,
        capaciteTotale: 18,
        seuilMinimum: 10,
        recetteTotale: 3600,
        statut: TrajetStatut.confirme,
        positionDepart: const LatLng(6.3654, 2.4183),
        positionArrivee: const LatLng(6.4031, 2.3439),
        passagers: [],
      ),
      Trajet(
        id: '3',
        plaque: 'AC-9101-BJ',
        depart: 'Agla',
        arrivee: 'IITA',
        heure: '21:30',
        date: DateTime.now(),
        conducteurNom: 'Thomas Dossou',
        conducteurTel: '+229 95 44 55 66',
        passagersActuels: 5,
        capaciteTotale: 16,
        seuilMinimum: 10,
        recetteTotale: 1000,
        statut: TrajetStatut.risque,
        positionDepart: const LatLng(6.3738, 2.3871),
        positionArrivee: const LatLng(6.4103, 2.3089),
        passagers: [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.directions_bus_outlined),
            SizedBox(width: 8),
            Text('Trajets MonTrajet'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNouveauTrajetDialog(context),
            tooltip: 'Nouveau trajet',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          Expanded(
            child: _showMap ? _buildMapView() : _buildListView(),
          ),
          _buildPagination(),
        ],
      ),
      drawer: const AppNavigationDrawer(),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un trajet...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tous'),
                const SizedBox(width: 8),
                _buildFilterChip('Aujourd\'hui'),
                const SizedBox(width: 8),
                _buildFilterChip('Demain'),
                const SizedBox(width: 8),
                _buildFilterChip('Cette semaine'),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showMap = !_showMap),
                  icon: Icon(_showMap ? Icons.list : Icons.map),
                  label: Text(_showMap ? 'Voir liste' : 'Voir carte'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filtreActuel == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _filtreActuel = label),
      backgroundColor: AppColors.grey100,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

  Widget _buildMapView() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(6.3654, 2.4183),
        initialZoom: 10.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'app.tokpa.montrajet',
          tileProvider: NetworkTileProvider(),
          evictErrorTileStrategy: EvictErrorTileStrategy.dispose,
        ),
        MarkerLayer(
          markers: _mockTrajets.map((trajet) {
            if (trajet.positionDepart == null) return null;
            return Marker(
              point: trajet.positionDepart!,
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _showTrajetInfo(context, trajet),
                child: Container(
                  decoration: BoxDecoration(
                    color: trajet.statut.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_bus,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).whereType<Marker>().toList(),
        ),
        MarkerLayer(
          markers: _mockTrajets.map((trajet) {
            if (trajet.positionArrivee == null) return null;
            return Marker(
              point: trajet.positionArrivee!,
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _showTrajetInfo(context, trajet),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.flag,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).whereType<Marker>().toList(),
        ),
        PolylineLayer(
          polylines: _mockTrajets.where((t) => t.positionDepart != null && t.positionArrivee != null).map((trajet) {
            return Polyline(
              points: [trajet.positionDepart!, trajet.positionArrivee!],
              color: trajet.statut.color,
              strokeWidth: 3.0,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _mockTrajets.length,
      itemBuilder: (context, index) {
        final trajet = _mockTrajets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TrajetCard(
            plaque: trajet.plaque,
            depart: trajet.depart,
            arrivee: trajet.arrivee,
            heure: trajet.heure,
            conducteurNom: trajet.conducteurNom,
            conducteurTel: trajet.conducteurTel,
            passagersActuels: trajet.passagersActuels,
            capaciteTotale: trajet.capaciteTotale,
            pourcentageRemplissage: trajet.pourcentageRemplissage,
            montantRecette: trajet.recetteFormatee,
            statut: trajet.statut.label,
            statutColor: trajet.statut.color,
            onVoirDetails: () => _voirDetails(context, trajet),
            onModifier: () => _modifierTrajet(context, trajet),
            onSMSListe: () => _envoyerSMSListe(context, trajet),
            onAnnuler: () => _annulerTrajet(context, trajet),
          ),
        );
      },
    );
  }

  void _showTrajetInfo(BuildContext context, Trajet trajet) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trajet.plaque,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${trajet.depart} -> ${trajet.arrivee}',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Heure: ${trajet.heure}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: trajet.statut.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trajet.statut.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: trajet.statut.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _voirDetails(context, trajet);
                  },
                  child: const Text('Voir details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNouveauTrajetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau trajet'),
        content: const Text('Fonctionnalite a implementer'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _voirDetails(BuildContext context, Trajet trajet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrajetDetailScreen(trajet: trajet),
      ),
    );
  }

  void _modifierTrajet(BuildContext context, Trajet trajet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modifier ${trajet.plaque}')),
    );
  }

  void _envoyerSMSListe(BuildContext context, Trajet trajet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Envoyer SMS liste pour ${trajet.plaque}')),
    );
  }

  void _annulerTrajet(BuildContext context, Trajet trajet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler le trajet'),
        content: Text('Etes-vous sur de vouloir annuler le trajet ${trajet.plaque} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Trajet ${trajet.plaque} annule')),
              );
            },
            child: Text(
              'Oui, annuler',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
