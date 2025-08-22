import SwiftUI

struct AppColors {
    // Couleurs principales
    static let primary = Color(hex: "0E5A9C")
    static let accent = Color(hex: "21B1FF")
    
    // Couleurs des tables
    static let tableGreen = Color(hex: "0F6A5B")
    static let tableBlue = Color(hex: "0B5589")
    static let woodDark = Color(hex: "4C2E1A")
    
    // Couleurs des jetons
    static let gold = Color(hex: "D7B55A")
    static let chipRed = Color(hex: "CF3030")
    static let chipBlue = Color(hex: "3E78FF")
    static let chipGreen = Color(hex: "129644")
    
    // Couleurs UI
    static let background = Color.black
    static let surface = Color(hex: "1A1A1A")
    static let card = Color(hex: "2A2A2A")
    static let text = Color.white
    static let textSecondary = Color(hex: "CCCCCC")
    static let success = Color(hex: "4CAF50")
    static let error = Color(hex: "F44336")
    static let warning = Color(hex: "FF9800")
    
    // Couleurs des cartes
    static let cardRed = Color(hex: "D32F2F")
    static let cardBlack = Color(hex: "212121")
    static let cardGreen = Color(hex: "388E3C")
    static let cardBack = Color(hex: "1976D2")
}

// Extension pour les gradients
extension AppColors {
    static let primaryGradient = LinearGradient(
        colors: [primary, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tableGradient = LinearGradient(
        colors: [tableGreen, tableBlue],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let chipGradient = LinearGradient(
        colors: [gold, Color(hex: "B8860B")],
        startPoint: .top,
        endPoint: .bottom
    )
}
