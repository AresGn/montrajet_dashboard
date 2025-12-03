/// Entité représentant un passager inscrit sur un trajet
class Passager {
  final String id;
  final String prenom;
  final String telephone;
  final String depart;
  final String arrivee;
  final int montant;
  final bool estConfirme;
  final DateTime? dateInscription;

  const Passager({
    required this.id,
    required this.prenom,
    required this.telephone,
    required this.depart,
    required this.arrivee,
    required this.montant,
    this.estConfirme = true,
    this.dateInscription,
  });

  String get montantFormate => '${montant}F';

  Passager copyWith({
    String? id,
    String? prenom,
    String? telephone,
    String? depart,
    String? arrivee,
    int? montant,
    bool? estConfirme,
    DateTime? dateInscription,
  }) {
    return Passager(
      id: id ?? this.id,
      prenom: prenom ?? this.prenom,
      telephone: telephone ?? this.telephone,
      depart: depart ?? this.depart,
      arrivee: arrivee ?? this.arrivee,
      montant: montant ?? this.montant,
      estConfirme: estConfirme ?? this.estConfirme,
      dateInscription: dateInscription ?? this.dateInscription,
    );
  }
}
