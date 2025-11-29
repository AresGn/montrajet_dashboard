# MonTrajet Dashboard

Dashboard d'administration SMS-first pour la plateforme MonTrajet. Interface Flutter pour monitorer en temps réel les demandes passagers, trajets conducteurs, et matching intelligent.

## ✨ Fonctionnalités

- 🔐 **Authentification Supabase** - Email/Password + Phone Auth
- 📊 **Dashboard en temps réel** - Métriques quotidiennes et alertes en direct
- 🚐 **Gestion des trajets** - Création, confirmation, annulation, édition
- 💬 **Gestion des SMS** - Parsing intelligent par IA (Grok/Claude/Gemini)
- 🚗 **Covoiturages réguliers** - Gestion des trajets récurrents et matching
- 📱 **Envoi groupé SMS** - Twilio ou Africa's Talking
- 📊 **Graphiques & Exports** - Visualisations et exportation CSV/PDF
- 🔔 **Alertes temps réel** - Système d'alertes visuelles
- 📈 **Rapports analytiques** - Statistiques détaillées et rapports

## 🛠 Stack Technique

- **UI**: Flutter 3.24+
- **State Management**: Riverpod 2.0+
- **Backend**: Supabase (PostgreSQL + Realtime + Auth)
- **Parsing IA**: Grok-4, Claude 3.5, ou Gemini 1.5
- **Charts**: fl_chart
- **SMS Gateway**: Twilio ou Africa's Talking

## 🚀 Démarrage rapide

### Prérequis
- Flutter 3.24 ou supérieur
- Dart 3.0 ou supérieur
- Un compte Supabase
- Un compte SMS Gateway (Twilio ou Africa's Talking)

### Installation

```bash
# 1. Cloner le repo
git clone https://github.com/montrajet/montrajet_dashboard.git
cd montrajet_dashboard

# 2. Installer les dépendances Flutter
flutter pub get

# 3. Configurer l'environnement
cp .env.example .env
# Éditer .env avec vos credentials

# 4. Lancer l'application
flutter run

# Pour web:
flutter run -d chrome

# Pour Android:
flutter run -d android

# Pour iOS:
flutter run -d ios
```

## 📝 Configuration (.env)

```env
SUPABASE_URL=https://xxxxxxxx.supabase.co
SUPABASE_ANON_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_SID=ACxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+229xxxxxxxx
LLM_PROVIDER=grok  # grok, claude, ou gemini
LLM_API_KEY=sk-...
ADMIN_EMAILS=admin@tokpa.app,superadmin@tokpa.app
```

## 📁 Structure du projet

```
lib/
├── main.dart
├── core/
│   ├── config/          # Configuration (Supabase, env)
│   ├── theme/           # Thème et styles
│   ├── constants/       # Constantes de l'app
│   └── utils/           # Utilitaires (logger, dates, validations)
├── features/            # Clean Architecture
│   ├── auth/            # Feature authentification
│   ├── dashboard/       # Feature dashboard
│   ├── trajets/         # Feature trajets
│   ├── sms/             # Feature SMS
│   └── covoiturage/     # Feature covoiturages
└── shared/              # Widgets partagés
```

## 🧪 Tests

```bash
# Tests unitaires
flutter test

# Couverture de code
flutter test --coverage
```

## 📦 Build & Déploiement

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche de feature (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'Add some amazing feature'`)
4. Push vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 License

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 👥 Équipe & Support

- **Lead Dev & Produit**: Aristide Tokpa
- **Email**: contact@tokpa.app
- **WhatsApp**: Groupe admins MonTrajet

## 🐛 Signaler un bug

Veuillez créer une issue sur [GitHub Issues](https://github.com/montrajet/montrajet_dashboard/issues) avec:
- Une description claire du bug
- Les étapes pour le reproduire
- Les résultats attendus vs. réels
- Les screenshots si applicables

## 🎯 Roadmap

- [ ] Support du Phone Auth (SMS)
- [ ] Intégration WhatsApp API
- [ ] Dashboard Admin avancé
- [ ] Analytics & Insights
- [ ] Mobile app (iOS/Android)
- [ ] Desktop apps (Windows/macOS)

---

**MonTrajet — Le transport partagé béninois qui fonctionne vraiment.** 🚐💨
