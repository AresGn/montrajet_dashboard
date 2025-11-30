import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/navigation_drawer.dart';
import '../widgets/trajet_card.dart';

enum TrajetStatut {
  enAttente,
  confirme,
  risque,
}

class Trajet {
  final String id;
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
  final TrajetStatut statut;
  final LatLng positionDepart;
  final LatLng positionArrivee;

  Trajet({
    required this.id,
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
    required this.positionDepart,
    required this.positionArrivee,
  });

  String get statutTexte {
    switch (statut) {
      case TrajetStatut.enAttente:
        return 'EN_ATTENTE';
      case TrajetStatut.confirme:
        return 'CONFIRMÉ';
      case TrajetStatut.risque:
        return 'RISQUE';
    }
  }

  Color get statutColor {
    switch (statut) {
      case TrajetStatut.enAttente:
        return AppColors.warning;
      case TrajetStatut.confirme:
        return AppColors.success;
      case TrajetStatut.risque:
        return AppColors.danger;
    }
  }
}

class TrajetsListScreen extends StatefulWidget {
  const TrajetsListScreen({super.key});

  @override
  State<TrajetsListScreen> createState() => _TrajetsListScreenState();
}

class _TrajetsListScreenState extends State<TrajetsListScreen> {
  int _currentPage = 1;
  int _totalPages = 4;
  String _filtreActuel = 'Tous';
  String _filtreDate = 'Aujourd\'hui';
  final TextEditingController _searchController = TextEditingController();
  bool _showMap = false;

  final List<Trajet> _mockTrajets = [
    Trajet(
      id: '1',
      plaque: 'AA-1234-BJ',
      depart: 'Akpakpa',
      arrivee: 'Calavi',
      heure: '22:00',
      conducteurNom: 'Jean Koffi',
      conducteurTel: '+229 97 12 34 56',
      passagersActuels: 12,
      capaciteTotale: 20,
      pourcentageRemplissage: 0.6,
      montantRecette: '2,400F',
      statut: TrajetStatut.enAttente,
      positionDepart: LatLng(6.3654, 2.4183),
      positionArrivee: LatLng(6.4167, 2.2833),
    ),
    Trajet(
      id: '2',
      plaque: 'AB-5678-BJ',
      depart: 'Cotonou',
      arrivee: 'Godomey',
      heure: '06:30',
      conducteurNom: 'Marie Houessou',
      conducteurTel: '+229 96 78 90 12',
      passagersActuels: 18,
      capaciteTotale: 18,
      pourcentageRemplissage: 1.0,
      montantRecette: '3,600F',
      statut: TrajetStatut.confirme,
      positionDepart: LatLng(6.3654, 2.4183),
      positionArrivee: LatLng(6.4031, 2.3439),
    ),
    Trajet(
      id: '3',
      plaque: 'AC-9101-BJ',
      depart: 'Agla',
      arrivee: 'IITA',
      heure: '21:30',
      conducteurNom: 'Thomas Dossou',
      conducteurTel: '+229 95 44 55 66',
      passagersActuels: 5,
      capaciteTotale: 16,
      pourcentageRemplissage: 0.31,
      montantRecette: '1,000F',
      statut: TrajetStatut.risque,
      positionDepart: LatLng(6.3738, 2.3871),
      positionArrivee: LatLng(6.4103, 2.3089),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.directions_bus_outlined),
            const SizedBox(width: 8),
            const Text('Trajets MonTrajet'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNouveauTrajetDialog(context);
            },
            tooltip: 'Nouveau trajet',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres et recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Bar de recherche
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
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),

                // Filtres
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
                        onPressed: () {
                          setState(() {
                            _showMap = !_showMap;
                          });
                        },
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
          ),

          // Contenu principal (Carte ou Liste)
          Expanded(
            child: _showMap ? _buildMapView() : _buildListView(),
          ),

          // Pagination
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Précédent',
                ),
                const SizedBox(width: 16),
                Text(
                  'Page $_currentPage/$_totalPages',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: _currentPage < _totalPages
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Suivant',
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppNavigationDrawer(),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filtreActuel == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtreActuel = label;
        });
      },
      backgroundColor: AppColors.grey100,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildMapView() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(6.3654, 2.4183),
        initialZoom: 10.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        // Marqueurs des trajets
        MarkerLayer(
          markers: _mockTrajets.map((trajet) {
            return Marker(
              point: trajet.positionDepart,
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => _showTrajetInfo(context, trajet),
                child: Container(
                  decoration: BoxDecoration(
                    color: trajet.statutColor,
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
          }).toList(),
        ),
        // Marqueurs d'arrivée
        MarkerLayer(
          markers: _mockTrajets.map((trajet) {
            return Marker(
              point: trajet.positionArrivee,
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
          }).toList(),
        ),
        // Lignes des trajets
        PolylineLayer(
          polylines: _mockTrajets.map((trajet) {
            return Polyline(
              points: [trajet.positionDepart, trajet.positionArrivee],
              color: trajet.statutColor,
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
            montantRecette: trajet.montantRecette,
            statut: trajet.statutTexte,
            statutColor: trajet.statutColor,
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
              '${trajet.depart} → ${trajet.arrivee}',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Heure: ${trajet.heure}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: trajet.statutColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                trajet.statutTexte,
                style: AppTextStyles.bodySmall.copyWith(
                  color: trajet.statutColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
        content: const Text('Fonctionnalité à implémenter'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voir détails de ${trajet.plaque}'),
      ),
    );
  }

  void _modifierTrajet(BuildContext context, Trajet trajet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modifier ${trajet.plaque}'),
      ),
    );
  }

  void _envoyerSMSListe(BuildContext context, Trajet trajet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Envoyer SMS liste pour ${trajet.plaque}'),
      ),
    );
  }

  void _annulerTrajet(BuildContext context, Trajet trajet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler le trajet'),
        content: Text('Êtes-vous sûr de vouloir annuler le trajet ${trajet.plaque} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Trajet ${trajet.plaque} annulé'),
                ),
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
