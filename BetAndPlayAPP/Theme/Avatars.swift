import SwiftUI

struct AvatarData: Identifiable, Codable {
    let id: Int
    let iconName: String
    let name: String
    let colorHex: String
    let isPremium: Bool
    let rarity: AvatarRarity
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    enum AvatarRarity: String, Codable, CaseIterable {
        case common = "common"
        case rare = "rare"
        case epic = "epic"
        case legendary = "legendary"
        
        var displayName: String {
            switch self {
            case .common: return "Commun"
            case .rare: return "Rare"
            case .epic: return "Épique"
            case .legendary: return "Légendaire"
            }
        }
        
        var color: Color {
            switch self {
            case .common: return Color.gray
            case .rare: return Color.blue
            case .epic: return Color.purple
            case .legendary: return Color.orange
            }
        }
    }
}

struct AppAvatars {
    static let allAvatars: [AvatarData] = [
        // AVATARS LÉGENDAIRES (Orange)
        AvatarData(id: 1, iconName: "crown.fill", name: "Roi du Casino", colorHex: "D7B55A", isPremium: true, rarity: .legendary),
        AvatarData(id: 2, iconName: "diamond.fill", name: "Diamant Noir", colorHex: "000000", isPremium: true, rarity: .legendary),
        AvatarData(id: 3, iconName: "star.fill", name: "Étoile Filante", colorHex: "D7B55A", isPremium: true, rarity: .legendary),
        AvatarData(id: 4, iconName: "bolt.fill", name: "Foudre Divine", colorHex: "D7B55A", isPremium: true, rarity: .legendary),
        AvatarData(id: 5, iconName: "flame.fill", name: "Dragon de Feu", colorHex: "FF0000", isPremium: true, rarity: .legendary),
        
        // AVATARS ÉPIQUES (Violet)
        AvatarData(id: 6, iconName: "sparkles", name: "Magicien", colorHex: "800080", isPremium: true, rarity: .epic),
        AvatarData(id: 7, iconName: "moon.fill", name: "Lune Noire", colorHex: "4B0082", isPremium: true, rarity: .epic),
        AvatarData(id: 8, iconName: "sun.max.fill", name: "Soleil Levant", colorHex: "FFA500", isPremium: true, rarity: .epic),
        AvatarData(id: 9, iconName: "cloud.bolt.fill", name: "Tempête", colorHex: "0000FF", isPremium: true, rarity: .epic),
        AvatarData(id: 10, iconName: "leaf.fill", name: "Nature", colorHex: "008000", isPremium: true, rarity: .epic),
        
        // AVATARS RARES (Bleu)
        AvatarData(id: 11, iconName: "heart.fill", name: "Cœur Rouge", colorHex: "FF0000", isPremium: false, rarity: .rare),
        AvatarData(id: 12, iconName: "suit.club.fill", name: "Trèfle", colorHex: "008000", isPremium: false, rarity: .rare),
        AvatarData(id: 13, iconName: "suit.spade.fill", name: "Pique", colorHex: "000000", isPremium: false, rarity: .rare),
        AvatarData(id: 14, iconName: "suit.heart.fill", name: "Cœur", colorHex: "FF0000", isPremium: false, rarity: .rare),
        AvatarData(id: 15, iconName: "suit.diamond.fill", name: "Carreau", colorHex: "FF0000", isPremium: false, rarity: .rare),
        AvatarData(id: 16, iconName: "dice.fill", name: "Dé Chanceux", colorHex: "D7B55A", isPremium: false, rarity: .rare),
        AvatarData(id: 17, iconName: "gamecontroller.fill", name: "Gamer Pro", colorHex: "800080", isPremium: false, rarity: .rare),
        AvatarData(id: 18, iconName: "trophy.fill", name: "Champion", colorHex: "D7B55A", isPremium: false, rarity: .rare),
        AvatarData(id: 19, iconName: "medal.fill", name: "Médaillé", colorHex: "D7B55A", isPremium: false, rarity: .rare),
        AvatarData(id: 20, iconName: "shield.fill", name: "Protecteur", colorHex: "0000FF", isPremium: false, rarity: .rare),
        
        // AVATARS COMMUNS (Gris)
        AvatarData(id: 21, iconName: "person.circle.fill", name: "Classique", colorHex: "808080", isPremium: false, rarity: .common),
        AvatarData(id: 22, iconName: "person.crop.circle.fill", name: "Standard", colorHex: "0000FF", isPremium: false, rarity: .common),
        AvatarData(id: 23, iconName: "person.crop.circle.badge.plus", name: "Nouveau", colorHex: "008000", isPremium: false, rarity: .common),
        AvatarData(id: 24, iconName: "person.crop.circle.badge.checkmark", name: "Vérifié", colorHex: "0000FF", isPremium: false, rarity: .common),
        AvatarData(id: 25, iconName: "person.crop.circle.badge.questionmark", name: "Mystère", colorHex: "FFA500", isPremium: false, rarity: .common),
        AvatarData(id: 26, iconName: "person.2.fill", name: "Social", colorHex: "0000FF", isPremium: false, rarity: .common),
        AvatarData(id: 27, iconName: "person.3.fill", name: "Groupe", colorHex: "008000", isPremium: false, rarity: .common),
        AvatarData(id: 28, iconName: "person.badge.plus", name: "VIP", colorHex: "D7B55A", isPremium: false, rarity: .common),
        AvatarData(id: 29, iconName: "person.badge.shield", name: "Sécurisé", colorHex: "0000FF", isPremium: false, rarity: .common),
        AvatarData(id: 30, iconName: "person.badge.key", name: "Accès", colorHex: "FFA500", isPremium: false, rarity: .common),
        
        // AVATARS THÉMATIQUES
        AvatarData(id: 31, iconName: "car.fill", name: "Pilote", colorHex: "FF0000", isPremium: false, rarity: .rare),
        AvatarData(id: 32, iconName: "airplane", name: "Aviateur", colorHex: "0000FF", isPremium: false, rarity: .rare),
        AvatarData(id: 33, iconName: "sailboat.fill", name: "Marin", colorHex: "0000FF", isPremium: false, rarity: .rare),
        AvatarData(id: 34, iconName: "bicycle", name: "Cycliste", colorHex: "008000", isPremium: false, rarity: .rare),
        AvatarData(id: 35, iconName: "motorcycle", name: "Motard", colorHex: "000000", isPremium: false, rarity: .rare),
        AvatarData(id: 36, iconName: "bus.fill", name: "Voyageur", colorHex: "0000FF", isPremium: false, rarity: .rare),
        AvatarData(id: 37, iconName: "tram.fill", name: "Citadin", colorHex: "008000", isPremium: false, rarity: .rare),
        AvatarData(id: 38, iconName: "cablecar.fill", name: "Montagnard", colorHex: "8B4513", isPremium: false, rarity: .rare),
        AvatarData(id: 39, iconName: "ferry.fill", name: "Navigateur", colorHex: "0000FF", isPremium: false, rarity: .rare),
        AvatarData(id: 40, iconName: "cart.fill", name: "Commerçant", colorHex: "FFA500", isPremium: false, rarity: .rare),
        
        // AVATARS SPORTIFS
        AvatarData(id: 41, iconName: "sportscourt.fill", name: "Sportif", colorHex: "008000", isPremium: false, rarity: .common),
        AvatarData(id: 42, iconName: "basketball.fill", name: "Basketteur", colorHex: "FFA500", isPremium: false, rarity: .common),
        AvatarData(id: 43, iconName: "football.fill", name: "Footballeur", colorHex: "FFFFFF", isPremium: false, rarity: .common),
        AvatarData(id: 44, iconName: "baseball.fill", name: "Baseballeur", colorHex: "FF0000", isPremium: false, rarity: .common),
        AvatarData(id: 45, iconName: "tennis.racket", name: "Tennisman", colorHex: "008000", isPremium: false, rarity: .common),
        AvatarData(id: 46, iconName: "volleyball.fill", name: "Volleyeur", colorHex: "0000FF", isPremium: false, rarity: .common),
        AvatarData(id: 47, iconName: "hockey.puck.fill", name: "Hockeyeur", colorHex: "000000", isPremium: false, rarity: .common),
        AvatarData(id: 48, iconName: "cricket", name: "Cricketeur", colorHex: "008000", isPremium: false, rarity: .common),
        AvatarData(id: 49, iconName: "rugby.ball.fill", name: "Rugbyman", colorHex: "FFA500", isPremium: false, rarity: .common),
        AvatarData(id: 50, iconName: "golf", name: "Golfeur", colorHex: "008000", isPremium: false, rarity: .common),
        
        // AVATARS ARTISTIQUES
        AvatarData(id: 51, iconName: "paintbrush.fill", name: "Artiste", colorHex: "800080", isPremium: false, rarity: .rare),
        AvatarData(id: 52, iconName: "paintpalette.fill", name: "Peintre", colorHex: "FFC0CB", isPremium: false, rarity: .rare),
        AvatarData(id: 53, iconName: "camera.fill", name: "Photographe", colorHex: "000000", isPremium: false, rarity: .rare),
        AvatarData(id: 54, iconName: "video.fill", name: "Vidéaste", colorHex: "FF0000", isPremium: false, rarity: .rare),
        AvatarData(id: 55, iconName: "music.note", name: "Musicien", colorHex: "800080", isPremium: false, rarity: .rare),
        AvatarData(id: 56, iconName: "guitars", name: "Guitariste", colorHex: "8B4513", isPremium: false, rarity: .rare),
        AvatarData(id: 57, iconName: "pianokeys", name: "Pianiste", colorHex: "000000", isPremium: false, rarity: .rare),
        AvatarData(id: 58, iconName: "mic.fill", name: "Chanteur", colorHex: "FFC0CB", isPremium: false, rarity: .rare),
        AvatarData(id: 59, iconName: "theatermasks.fill", name: "Acteur", colorHex: "800080", isPremium: false, rarity: .rare),
        AvatarData(id: 60, iconName: "book.fill", name: "Écrivain", colorHex: "8B4513", isPremium: false, rarity: .rare)
    ]
    
    static func getAvatar(by id: Int) -> AvatarData? {
        return allAvatars.first { $0.id == id }
    }
    
    static func getDefaultAvatar() -> AvatarData {
        return allAvatars.first { $0.id == 21 } ?? allAvatars[0]
    }
    
    static func getAvatarsByRarity(_ rarity: AvatarData.AvatarRarity) -> [AvatarData] {
        return allAvatars.filter { $0.rarity == rarity }
    }
    
    static func getPremiumAvatars() -> [AvatarData] {
        return allAvatars.filter { $0.isPremium }
    }
}
