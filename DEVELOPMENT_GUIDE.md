# 🚀 Guide de développement des features

## Architecture Clean + Riverpod

Le projet suit une architecture **Clean Architecture** avec **Riverpod** pour le state management.

### Structure d'une feature

```
features/nom_feature/
├── data/
│   ├── models/              # Models (conversion JSON)
│   │   └── xxx_model.dart
│   └── repositories/        # Implementation des repositories
│       └── xxx_repository_impl.dart
├── domain/
│   ├── entities/            # Entités (objets métier)
│   │   └── xxx.dart
│   ├── repositories/        # Contrats des repositories (abstraits)
│   │   └── xxx_repository.dart
│   └── usecases/            # Cas d'usage
│       └── xxx_usecase.dart
└── presentation/
    ├── providers/           # Riverpod providers
    │   └── xxx_provider.dart
    ├── screens/             # Pages/Écrans
    │   └── xxx_screen.dart
    └── widgets/             # Widgets réutilisables
        └── xxx_widget.dart
```

---

## 📋 Example: Feature Auth (Authentification)

### 1. Entité (domain/entities/user.dart)

```dart
class User {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  
  User({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
  });
}
```

### 2. Model (data/models/user_model.dart)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    super.displayName,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    email: user.email,
    displayName: user.displayName,
    createdAt: user.createdAt,
  );
}
```

### 3. Repository Abstract (domain/repositories/auth_repository.dart)

```dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAuthenticated();
}
```

### 4. Repository Implementation (data/repositories/auth_repository_impl.dart)

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepositoryImpl({required this.supabaseClient});

  @override
  Future<User?> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        return UserModel(
          id: response.user!.id,
          email: response.user!.email ?? '',
          displayName: response.user!.userMetadata?['display_name'],
          createdAt: response.user!.createdAt,
        );
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'],
        createdAt: user.createdAt,
      );
    }
    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return supabaseClient.auth.currentUser != null;
  }
}
```

### 5. Provider (presentation/providers/auth_provider.dart)

```dart
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../core/config/supabase_config.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Instancer le repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    supabaseClient: SupabaseConfig.client,
  );
});

// State du user actuel
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.getCurrentUser();
});

// State de l'authentification
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.isAuthenticated();
});

// Login
final loginProvider = FutureProvider.family<User?, Map<String, String>>((
  ref,
  credentials,
) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final user = await authRepository.login(
    credentials['email']!,
    credentials['password']!,
  );
  
  // Refresh l'utilisateur courant
  ref.refresh(currentUserProvider);
  
  return user;
});

// Logout
final logoutProvider = FutureProvider<void>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  await authRepository.logout();
  
  // Refresh l'utilisateur courant
  ref.refresh(currentUserProvider);
});
```

### 6. Screen (presentation/screens/login_screen.dart)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    setState(() => isLoading = true);

    try {
      final credentials = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final user = await ref.read(
        loginProvider(credentials).future,
      );

      if (user != null && mounted) {
        // Navigation au dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚐 MonTrajet - Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'admin@tokpa.app',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔗 Intégration avec Supabase Realtime

Pour les streams temps réel (SMS, trajets, alertes):

```dart
// Provider pour stream
final smsStreamProvider = StreamProvider<List<SMSMessage>>((ref) {
  return SupabaseConfig.client
      .from('sms_messages')
      .on(RealtimeListenTypes.all, FeatureSet(enabled: ['*']))
      .asyncMap((payload) async {
        // Convertir les payloads en SMSMessage
        return [...];
      })
      .asBroadcastStream();
});
```

---

## 📊 Gestion des états avec Riverpod

### AsyncValue (pour les données asynchrones)

```dart
final dataProvider = FutureProvider<MyData>((ref) async {
  // Récupérer les données
});

// Dans un widget
ref.watch(dataProvider).when(
  data: (data) => Text(data.toString()),
  loading: () => const LoadingWidget(),
  error: (error, stackTrace) => ErrorWidget(message: error.toString()),
);
```

### StateProvider (pour l'état mutable)

```dart
final countProvider = StateProvider<int>((ref) => 0);

// Lecture
final count = ref.watch(countProvider);

// Écriture
ref.read(countProvider.notifier).state++;
```

---

## 🧪 Tests

### Test du Repository

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('AuthRepository', () {
    test('login returns user on success', () async {
      // Arrange
      final mockSupabase = MockSupabaseClient();
      final repository = AuthRepositoryImpl(
        supabaseClient: mockSupabase,
      );

      // Act
      final user = await repository.login('test@example.com', 'password');

      // Assert
      expect(user, isNotNull);
      expect(user?.email, 'test@example.com');
    });
  });
}
```

---

## 📚 Ressources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev)
- [Supabase Flutter](https://supabase.com/docs/reference/dart/introduction)
- [Flutter Best Practices](https://flutter.dev/docs/development/best-practices)

---

## ✅ Checklist pour une nouvelle feature

- [ ] Créer les entités (`domain/entities`)
- [ ] Créer les models (`data/models`)
- [ ] Créer le repository abstract (`domain/repositories`)
- [ ] Implémenter le repository (`data/repositories`)
- [ ] Créer les providers (`presentation/providers`)
- [ ] Créer le screen (`presentation/screens`)
- [ ] Créer les widgets réutilisables (`presentation/widgets`)
- [ ] Écrire les tests unitaires
- [ ] Documenter la feature
- [ ] Tester sur les platforms (Android, iOS, Web)

---

Bon développement! 🚀
