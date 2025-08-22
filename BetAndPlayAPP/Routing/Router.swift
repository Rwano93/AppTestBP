import SwiftUI
import Combine

class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentRoute: Route = .splash
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Écouter les changements de route
        $currentRoute
            .sink { [weak self] route in
                self?.handleRouteChange(route)
            }
            .store(in: &cancellables)
    }
    
    func navigate(to route: Route) {
        currentRoute = route
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    private func handleRouteChange(_ route: Route) {
        switch route {
        case .splash:
            // Attendre 2-3 secondes puis aller à l'auth
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.navigate(to: .auth)
            }
        case .auth:
            // Vérifier si l'utilisateur est connecté
            if AuthStore.shared.isAuthenticated {
                self.navigate(to: .hub)
            }
        case .hub:
            // Route principale, pas d'action spéciale
            break
        default:
            // Ajouter la route au path de navigation
            path.append(route)
        }
    }
    
    // Méthodes de navigation spécifiques
    func navigateToGame(_ game: GameType, buyIn: Int = 0) {
        navigate(to: .gameTable(game: game, buyIn: buyIn))
    }
    
    func navigateToReferral(code: String) {
        navigate(to: .referral(code: code))
    }
    
    // Deep linking
    func handleDeepLink(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else { return }
        
        switch host {
        case "join":
            if let tableParam = components.queryItems?.first(where: { $0.name == "table" })?.value,
               let game = GameType(rawValue: tableParam),
               let buyInParam = components.queryItems?.first(where: { $0.name == "buyin" })?.value,
               let buyIn = Int(buyInParam) {
                navigateToGame(game, buyIn: buyIn)
            }
        case "referral":
            if let codeParam = components.queryItems?.first(where: { $0.name == "code" })?.value {
                navigateToReferral(code: codeParam)
            }
        default:
            break
        }
    }
}
