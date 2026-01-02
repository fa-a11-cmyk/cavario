# Cavario - Equestrian Club Management

Application mobile Flutter complète pour la gestion d'un club équestre avec fonctionnalités avancées incluant backend, notifications push, paiements et chat en temps réel.

## ✨ Fonctionnalités

### 🔐 **Authentification & Sécurité**
- Connexion sécurisée pour les administrateurs
- Gestion des sessions utilisateur
- Stockage local sécurisé

### 👥 **Gestion des Membres**
- Ajout, modification et suppression des membres
- Types d'adhésion (Standard, Premium, VIP)
- Statuts de paiement
- Historique des paiements

### 📅 **Gestion des Événements**
- Création de cours, compétitions et stages
- Système d'inscription aux événements
- Notifications automatiques
- Tarification personnalisée

### 🗓️ **Planification**
- Calendrier interactif hebdomadaire
- Gestion des créneaux horaires
- Attribution des instructeurs
- Réservation des installations

### 🐎 **Gestion des Chevaux**
- Base de données complète des chevaux
- Suivi de l'état de santé
- Disponibilité et attribution
- Besoins spéciaux

### 🛠️ **Équipements**
- Inventaire des équipements
- Planification de la maintenance
- Statut de disponibilité

### 💬 **Chat Intégré**
- Communication en temps réel entre membres
- Messages système automatiques
- Interface moderne et intuitive

### 💳 **Système de Paiement**
- Intégration Stripe sécurisée
- Paiements des adhésions
- Historique des transactions
- Gestion des abonnements

### 🔔 **Notifications Push**
- Rappels d'événements
- Notifications Firebase
- Alertes personnalisées

### 🌐 **Intégration Backend**
- API REST complète
- Synchronisation des données
- Gestion des erreurs réseau

## 🚀 Installation

### Prérequis
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Émulateur Android/iOS ou appareil physique

### Étapes d'installation

1. **Cloner le repository**
   ```bash
   git clone https://github.com/fa-a11-cmyk/cavario.git
   cd cavario
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration Firebase (optionnel)**
   - Créer un projet Firebase
   - Ajouter les fichiers de configuration
   - Activer les notifications push

4. **Configuration Stripe (optionnel)**
   - Obtenir les clés API Stripe
   - Configurer dans `payment_service.dart`

5. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🔑 Connexion de Démonstration

- **Email** : admin@cavario.com
- **Mot de passe** : admin123

## 📱 Captures d'écran

### Interface Moderne
- Design responsive iOS/Android
- Thème équestre personnalisé
- Animations fluides
- Interface intuitive

## 🏗️ Architecture

### Structure du Projet
```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données
│   ├── member.dart             # Modèle Membre
│   ├── event.dart              # Modèle Événement
│   └── horse.dart              # Modèle Cheval & Équipement
├── screens/                     # Écrans de l'application
│   ├── login_screen.dart       # Connexion
│   ├── dashboard_screen.dart   # Tableau de bord
│   ├── members_screen.dart     # Gestion membres
│   ├── events_screen.dart      # Gestion événements
│   ├── schedule_screen.dart    # Planification
│   ├── horses_screen.dart      # Gestion chevaux
│   └── chat_screen.dart        # Chat temps réel
├── services/                    # Services métier
│   ├── auth_service.dart       # Authentification
│   ├── database_service.dart   # Base de données locale
│   ├── api_service.dart        # API REST
│   ├── notification_service.dart # Notifications
│   ├── payment_service.dart    # Paiements Stripe
│   └── chat_service.dart       # Chat Socket.IO
├── theme/                       # Thème personnalisé
│   └── app_theme.dart          # Couleurs et styles
└── widgets/                     # Composants réutilisables
    └── image_widget.dart       # Gestion d'images
```

## 🛠️ Technologies Utilisées

### Frontend
- **Flutter** - Framework de développement mobile
- **Provider** - Gestion d'état
- **Material Design** - Interface utilisateur

### Base de Données
- **SQLite** - Base de données locale
- **SharedPreferences** - Stockage des préférences

### Services Externes
- **Firebase** - Notifications push
- **Stripe** - Paiements sécurisés
- **Socket.IO** - Chat temps réel
- **REST API** - Communication backend

### Outils de Développement
- **Intl** - Internationalisation
- **HTTP** - Requêtes réseau
- **Path** - Gestion des chemins

## 🔮 Fonctionnalités Futures

- [ ] Application web responsive
- [ ] Système de réservation avancé
- [ ] Intégration calendrier externe
- [ ] Rapports et analytics
- [ ] Mode hors ligne
- [ ] Support multi-langues
- [ ] API GraphQL
- [ ] Tests automatisés

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Contact

- **Développeur** : [fa-a11-cmyk](https://github.com/fa-a11-cmyk)
- **Repository** : [https://github.com/fa-a11-cmyk/cavario](https://github.com/fa-a11-cmyk/cavario)

---

⭐ **N'hésitez pas à donner une étoile si ce projet vous plaît !**