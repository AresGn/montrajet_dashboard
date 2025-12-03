import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Direction du SMS (entrant ou sortant)
enum SmsDirection {
  entrant,
  sortant,
}

/// Type de message SMS parse par le LLM
enum SmsType {
  demandeTokpa,
  disponibiliteConducteur,
  confirmation,
  annulation,
  inconnu,
}

extension SmsTypeExtension on SmsType {
  String get label {
    switch (this) {
      case SmsType.demandeTokpa:
        return 'DEMANDE_TOKPA';
      case SmsType.disponibiliteConducteur:
        return 'DISPONIBILITE_CONDUCTEUR';
      case SmsType.confirmation:
        return 'CONFIRMATION';
      case SmsType.annulation:
        return 'ANNULATION';
      case SmsType.inconnu:
        return 'INCONNU';
    }
  }

  Color get color {
    switch (this) {
      case SmsType.demandeTokpa:
        return AppColors.info;
      case SmsType.disponibiliteConducteur:
        return AppColors.primary;
      case SmsType.confirmation:
        return AppColors.success;
      case SmsType.annulation:
        return AppColors.danger;
      case SmsType.inconnu:
        return AppColors.grey500;
    }
  }
}

/// Resultat du parsing LLM d'un SMS
class SmsParsedData {
  final SmsType type;
  final String? prenom;
  final String? depart;
  final String? arrivee;
  final int? montant;
  final String? heure;
  final int? capacite;
  final int? minimum;
  final double confiance;

  const SmsParsedData({
    required this.type,
    this.prenom,
    this.depart,
    this.arrivee,
    this.montant,
    this.heure,
    this.capacite,
    this.minimum,
    this.confiance = 0.0,
  });

  String get confianceFormatee => '${(confiance * 100).toInt()}%';
}

/// Entite representant un message SMS
class SmsMessage {
  final String id;
  final SmsDirection direction;
  final String telephone;
  final String contenu;
  final DateTime dateHeure;
  final bool estLu;
  final bool estDelivre;
  final SmsParsedData? parsedData;
  final String? actionResultat;
  final String? trajetAssocieId;

  const SmsMessage({
    required this.id,
    required this.direction,
    required this.telephone,
    required this.contenu,
    required this.dateHeure,
    this.estLu = false,
    this.estDelivre = false,
    this.parsedData,
    this.actionResultat,
    this.trajetAssocieId,
  });

  bool get estEntrant => direction == SmsDirection.entrant;
  bool get estSortant => direction == SmsDirection.sortant;
  bool get estParse => parsedData != null;

  String get heureFormatee {
    final h = dateHeure.hour.toString().padLeft(2, '0');
    final m = dateHeure.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  SmsMessage copyWith({
    String? id,
    SmsDirection? direction,
    String? telephone,
    String? contenu,
    DateTime? dateHeure,
    bool? estLu,
    bool? estDelivre,
    SmsParsedData? parsedData,
    String? actionResultat,
    String? trajetAssocieId,
  }) {
    return SmsMessage(
      id: id ?? this.id,
      direction: direction ?? this.direction,
      telephone: telephone ?? this.telephone,
      contenu: contenu ?? this.contenu,
      dateHeure: dateHeure ?? this.dateHeure,
      estLu: estLu ?? this.estLu,
      estDelivre: estDelivre ?? this.estDelivre,
      parsedData: parsedData ?? this.parsedData,
      actionResultat: actionResultat ?? this.actionResultat,
      trajetAssocieId: trajetAssocieId ?? this.trajetAssocieId,
    );
  }
}
