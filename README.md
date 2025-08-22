# CasinoX 3D - Application iOS

Une application de casino 3D complète développée en Swift/SwiftUI avec RealityKit pour iOS 16+.

## 🎰 Fonctionnalités

### Jeux Disponibles
- **Blackjack 3D** : Tables bois + tapis, side bets, dealer animé
- **Roulette 3D** : Roulette européenne, historique hot/cold
- **Baccarat 3D** : Punto/Banco/Tie, roadmaps
- **Poker 3D** : Texas Hold'em 6-max, HandEvaluator

### Système Économique
- **Wallet réactif** : Jetons (₿) et Gemmes (💎)
- **Solde initial** : 3 000 000 jetons + 100 gemmes
- **Transactions** : Historique complet avec animations
- **StoreKit 2** : Achats in-app sécurisés

### Fonctionnalités Sociales
- **Système d'amis** : Ajout, recherche, invitations
- **Parrainage** : Codes de parrainage avec bonus
- **Battle Pass** : Saison mensuelle avec récompenses
- **Récompenses quotidiennes** : Calendrier 7 jours

### Interface Utilisateur
- **Design moderne** : Glassmorphism, animations fluides
- **Orientation paysage** : Optimisé pour iPhone/iPad
- **Haptics** : Retour tactile pour les interactions
- **Accessibilité** : VoiceOver, Dynamic Type

## 🚀 Installation

### Prérequis
- Xcode 16+
- iOS 16+
- iPhone 16 Pro (recommandé pour les performances 3D)

### Étapes d'installation

1. **Cloner le projet**
   ```bash
   git clone [URL_DU_REPO]
   cd BetAndPlayAPP
   ```

2. **Ouvrir dans Xcode**
   ```bash
   open BetAndPlayAPP.xcodeproj
   ```

3. **Configuration du projet**
   - Sélectionner votre équipe de développement
   - Vérifier que le Bundle Identifier est unique
   - Configurer les capacités si nécessaire

4. **Lancer l'application**
   - Sélectionner un simulateur iPhone 16 Pro
   - Appuyer sur ⌘R ou le bouton Play

## 📱 Parcours Utilisateur

### Premier Lancement
1. **Écran Splash** (2-3 secondes) : Logo CasinoX + barre de progression
2. **Authentification** : Création de compte ou connexion
3. **Hub Principal** : Interface principale avec tous les jeux

### Navigation
- **Hub** : Accueil avec carousel de jeux
- **Profil** : Statistiques, niveau, XP
- **Amis** : Gestion des amis et invitations
- **Boutique** : Achats de jetons et gemmes
- **Battle Pass** : Progression saisonnière
- **Récompenses** : Calendrier quotidien

## 🎮 Jeux Disponibles

### Blackjack
- **Règles** : Sabot 6 paquets, S17, 3:2 Blackjack
- **Side Bets** : Perfect Pairs, 21+3, Insurance, Bet Behind
- **Actions** : Hit, Stand, Double, Split, Surrender

### Roulette
- **Type** : Roulette européenne (single zero)
- **Mises** : Plein, cheval, transversale, carré, sixain
- **Historique** : 10 derniers résultats

### Baccarat
- **Règles** : Punto/Banco/Tie, commission 5%
- **Tirage** : Automatique selon les règles
- **Roadmaps** : Bead plate simple

### Poker
- **Variante** : Texas Hold'em 6-max
- **Actions** : Check, Call, Bet, Raise, Fold
- **Side Bet** : Lucky Combo

## 💰 Économie

### Devises
- **Jetons (₿)** : Monnaie principale pour les jeux
- **Gemmes (💎)** : Monnaie premium pour les achats spéciaux

### Récompenses
- **Daily Reward** : 10k-120k jetons selon la série
- **Battle Pass** : Récompenses gratuites et premium
- **Parrainage** : 50k jetons bonus
- **Niveaux** : 1000 XP par niveau

### Boutique
- **Packs Jetons** : 2M à 350M jetons
- **Packs Gemmes** : 2000 à 12000 gemmes
- **Battle Pass Premium** : Accès aux récompenses premium

## 🔧 Architecture Technique

### Structure du Projet
```
BetAndPlayAPP/
├── App/
│   ├── CasinoXApp.swift          # Point d'entrée
│   ├── Theme/                    # Design system
│   ├── Routing/                  # Navigation
│   ├── Core/                     # Services principaux
│   ├── GameKit/                  # Moteurs de jeu
│   ├── UI/                       # Interfaces utilisateur
│   └── Assets/                   # Ressources
```

### Technologies Utilisées
- **SwiftUI** : Interface utilisateur moderne
- **RealityKit** : Rendu 3D et animations
- **Combine** : Programmation réactive
- **StoreKit 2** : Achats in-app
- **CoreData** : Persistance des données
- **WebSocket** : Communication temps réel

### Services Principaux
- **WalletStore** : Gestion des devises et transactions
- **AuthStore** : Authentification et profil utilisateur
- **DailyRewardService** : Récompenses quotidiennes
- **BattlePassService** : Progression saisonnière
- **RNGService** : Génération de nombres aléatoires
- **StoreKitService** : Gestion des achats

## 🎨 Design System

### Couleurs
- **Primary** : #0E5A9C (Bleu principal)
- **Accent** : #21B1FF (Bleu accent)
- **Gold** : #D7B55A (Or pour les jetons)
- **Success** : #4CAF50 (Vert succès)
- **Error** : #F44336 (Rouge erreur)

### Typographie
- **Large Title** : 34pt Bold
- **Title** : 28pt Semibold
- **Headline** : 17pt Semibold
- **Body** : 17pt Regular
- **Balance** : 24pt Monospaced

## 🔒 Sécurité

### Protection des Données
- **Chiffrement** : Données sensibles chiffrées
- **Validation** : Vérification des entrées utilisateur
- **Sécurité réseau** : Communication HTTPS/WebSocket sécurisée

### Conformité
- **App Store** : Respect des guidelines Apple
- **RGPD** : Protection des données personnelles
- **Jeu responsable** : Avertissements et contrôles

## 🧪 Tests

### Tests Unitaires
- **BlackjackEngineTests** : Logique du blackjack
- **RouletteEngineTests** : Logique de la roulette
- **WalletTests** : Gestion des transactions

### Tests UI
- **FlowSmokeTests** : Parcours utilisateur complets

## 📈 Performance

### Optimisations
- **60 FPS** : Rendu fluide sur iPhone 16 Pro
- **Metal** : Accélération GPU pour le 3D
- **Lazy Loading** : Chargement à la demande
- **Cache** : Mise en cache des ressources

### Monitoring
- **Métriques** : Temps de chargement, FPS
- **Crashlytics** : Rapport d'erreurs
- **Analytics** : Comportement utilisateur

## 🚀 Déploiement

### Configuration App Store
1. **Certificats** : Certificats de développement et distribution
2. **Profils** : Profils de provisionnement
3. **App Store Connect** : Configuration de l'application
4. **TestFlight** : Tests beta

### Build de Production
```bash
# Archive pour App Store
xcodebuild -project BetAndPlayAPP.xcodeproj \
           -scheme BetAndPlayAPP \
           -configuration Release \
           -archivePath BetAndPlayAPP.xcarchive \
           archive
```

## 🤝 Contribution

### Guidelines
- **Swift Style Guide** : Respecter les conventions Swift
- **Tests** : Ajouter des tests pour les nouvelles fonctionnalités
- **Documentation** : Commenter le code complexe
- **Code Review** : Validation par l'équipe

### Workflow
1. **Fork** du repository
2. **Feature branch** : `feature/nom-fonctionnalite`
3. **Commit** : Messages descriptifs
4. **Pull Request** : Description détaillée
5. **Review** : Validation et merge

## 📞 Support

### Contact
- **Email** : support@casinox.com
- **Documentation** : [docs.casinox.com](https://docs.casinox.com)
- **Issues** : [GitHub Issues](https://github.com/casinox/issues)

### FAQ
- **Problèmes de performance** : Vérifier la version iOS et l'appareil
- **Erreurs de paiement** : Contacter le support StoreKit
- **Problèmes de connexion** : Vérifier la connectivité réseau

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

**CasinoX 3D** - L'expérience casino la plus immersive sur iOS 🎰✨
# AppTestBP
