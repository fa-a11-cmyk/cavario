# Cavario - Equestrian Club Management

Application mobile Flutter pour la gestion complète d'un club équestre incluant la planification des membres et la coordination des événements.

## Fonctionnalités

- **Authentification** : Connexion sécurisée pour les administrateurs
- **Gestion des membres** : Ajout, modification et suppression des membres
- **Gestion des événements** : Création et gestion des cours, compétitions et stages
- **Planification** : Calendrier interactif pour la gestion des créneaux
- **Interface responsive** : Optimisée pour iOS et Android

## Installation

1. Assurez-vous d'avoir Flutter installé sur votre système
2. Clonez le projet ou téléchargez les fichiers
3. Naviguez vers le dossier du projet :
   ```bash
   cd cavario
   ```
4. Installez les dépendances :
   ```bash
   flutter pub get
   ```
5. Lancez l'application :
   ```bash
   flutter run
   ```

## Connexion de démonstration

- **Email** : admin@cavario.com
- **Mot de passe** : admin123

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données
│   ├── member.dart          # Modèle Membre
│   └── event.dart           # Modèle Événement
├── screens/                  # Écrans de l'application
│   ├── login_screen.dart    # Écran de connexion
│   ├── dashboard_screen.dart # Tableau de bord
│   ├── members_screen.dart  # Gestion des membres
│   ├── events_screen.dart   # Gestion des événements
│   └── schedule_screen.dart # Planification
└── services/                # Services
    └── auth_service.dart    # Service d'authentification
```

## Technologies utilisées

- **Flutter** : Framework de développement mobile
- **Provider** : Gestion d'état
- **SharedPreferences** : Stockage local
- **Intl** : Internationalisation et formatage des dates

## Prochaines étapes

- Intégration avec une base de données backend
- Notifications push pour les événements
- Système de paiement pour les adhésions
- Chat intégré entre membres
- Gestion des chevaux et équipements