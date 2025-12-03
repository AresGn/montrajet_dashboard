import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import 'passager.dart';

/// Statuts possibles d'un trajet
enum TrajetStatut {
  enAttente,
  confirme,
  risque,
  annule,
  termine,
}

/// Extension pour obtenir les propriétés d'affichage du statut
extension TrajetStatutExtension on TrajetStatut {
  String get label {
    switch (this) {
      case TrajetStatut.enAttente:
        return 'EN_ATTENTE';
      case TrajetStatut.confirme:
        return 'CONFIRME';
      case TrajetStatut.risque:
        return 'RISQUE';
      case TrajetStatut.annule:
        return 'ANNULE';
      case TrajetStatut.termine:
        return 'TERMINE';
    }
  }

  Color get color {
    switch (this) {
      case TrajetStatut.enAttente:
        return AppColors.warning;
      case TrajetStatut.confirme:
        return AppColors.success;
      case TrajetStatut.risque:
        return AppColors.danger;
      case TrajetStatut.annule:
        return AppColors.grey500;
      case TrajetStatut.termine:
        return AppColors.info;
    }
  }

  String get description {
    switch (this) {
      case TrajetStatut.enAttente:
        return 'seuil min requis';
      case TrajetStatut.confirme:
        return 'Trajet confirmé';
      case TrajetStatut.risque:
        return 'seuil non atteint';
      case TrajetStatut.annule:
        return 'Trajet annulé';
      case TrajetStatut.termine:
        return 'Trajet terminé';
    }
  }
}

/// Entité représentant un trajet complet
class Trajet {
  final String id;
  final String plaque;
  final String depart;
  final String arrivee;
  final String pointDepart;
  final String pointArrivee;
  final String heure;
  final DateTime date;
  final String conducteurNom;
  final String conducteurTel;
  final int passagersActuels;
  final int capaciteTotale;
  final int seuilMinimum;
  final int recetteTotale;
  final TrajetStatut statut;
  final LatLng? positionDepart;
  final LatLng? positionArrivee;
  final List<Passager> passagers;
  final Map<String, int> prixZones;

  Trajet({
    required this.id,
    required this.plaque,
    required this.depart,
    required this.arrivee,
    this.pointDepart = '',
    this.pointArrivee = '',
    required this.heure,
    required this.date,
    required this.conducteurNom,
    required this.conducteurTel,
    required this.passagersActuels,
    required this.capaciteTotale,
    this.seuilMinimum = 10,
    required this.recetteTotale,
    required this.statut,
    this.positionDepart,
    this.positionArrivee,
    List<Passager>? passagers,
    Map<String, int>? prixZones,
  })  : passagers = passagers ?? const [],
        prixZones = prixZones ?? const {};

  double get pourcentageRemplissage =>
      capaciteTotale > 0 ? passagersActuels / capaciteTotale : 0;

  String get recetteFormatee => '${_formatNumber(recetteTotale)}F';

  int get commissionTokpa => passagersActuels * 50;

  int get montantConducteur => recetteTotale - commissionTokpa;

  String get commissionFormatee => '${_formatNumber(commissionTokpa)}F';

  String get montantConducteurFormate => '${_formatNumber(montantConducteur)}F';

  bool get seuilAtteint => passagersActuels >= seuilMinimum;

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Trajet copyWith({
    String? id,
    String? plaque,
    String? depart,
    String? arrivee,
    String? pointDepart,
    String? pointArrivee,
    String? heure,
    DateTime? date,
    String? conducteurNom,
    String? conducteurTel,
    int? passagersActuels,
    int? capaciteTotale,
    int? seuilMinimum,
    int? recetteTotale,
    TrajetStatut? statut,
    LatLng? positionDepart,
    LatLng? positionArrivee,
    List<Passager>? passagers,
    Map<String, int>? prixZones,
  }) {
    return Trajet(
      id: id ?? this.id,
      plaque: plaque ?? this.plaque,
      depart: depart ?? this.depart,
      arrivee: arrivee ?? this.arrivee,
      pointDepart: pointDepart ?? this.pointDepart,
      pointArrivee: pointArrivee ?? this.pointArrivee,
      heure: heure ?? this.heure,
      date: date ?? this.date,
      conducteurNom: conducteurNom ?? this.conducteurNom,
      conducteurTel: conducteurTel ?? this.conducteurTel,
      passagersActuels: passagersActuels ?? this.passagersActuels,
      capaciteTotale: capaciteTotale ?? this.capaciteTotale,
      seuilMinimum: seuilMinimum ?? this.seuilMinimum,
      recetteTotale: recetteTotale ?? this.recetteTotale,
      statut: statut ?? this.statut,
      positionDepart: positionDepart ?? this.positionDepart,
      positionArrivee: positionArrivee ?? this.positionArrivee,
      passagers: passagers ?? this.passagers,
      prixZones: prixZones ?? this.prixZones,
    );
  }
}
