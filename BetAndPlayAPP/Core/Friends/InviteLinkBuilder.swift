import Foundation
#if canImport(UIKit)
import UIKit
#endif

class InviteLinkBuilder: ObservableObject {
    static let shared = InviteLinkBuilder()
    
    private init() {}
    
    func generateInviteLink(for user: User) -> String {
        let baseURL = "casinox://invite"
        let referralCode = user.referralCode
        return "\(baseURL)?code=\(referralCode)&user=\(user.username)"
    }
    
    func generateFriendInviteLink(for friend: Friend) -> String {
        let baseURL = "casinox://friend"
        return "\(baseURL)?id=\(friend.id)&user=\(friend.username)"
    }
    
    func shareInviteLink(for user: User, from viewController: UIViewController) {
        let inviteLink = generateInviteLink(for: user)
        let shareText = """
        Rejoins-moi sur CasinoX ! 🎰
        
        Utilise mon code de parrainage : \(user.referralCode)
        
        \(inviteLink)
        
        #CasinoX #JeuxCasino
        """
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // Exclure certaines activités
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks,
            .markupAsPDF
        ]
        
        // Présenter sur iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true)
    }
    
    func shareFriendInvite(for friend: Friend, from viewController: UIViewController) {
        let inviteLink = generateFriendInviteLink(for: friend)
        let shareText = """
        Rejoins \(friend.username) sur CasinoX ! 🎰
        
        \(inviteLink)
        
        #CasinoX #JeuxCasino
        """
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // Exclure certaines activités
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks,
            .markupAsPDF
        ]
        
        // Présenter sur iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true)
    }
    
    func copyInviteLinkToClipboard(for user: User) {
        let inviteLink = generateInviteLink(for: user)
        UIPasteboard.general.string = inviteLink
        
        // Feedback haptique
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func copyReferralCodeToClipboard(for user: User) {
        UIPasteboard.general.string = user.referralCode
        
        // Feedback haptique
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func parseInviteLink(_ url: URL) -> InviteLinkData? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return nil }
        
        var referralCode: String?
        var username: String?
        var friendId: String?
        
        for item in queryItems {
            switch item.name {
            case "code":
                referralCode = item.value
            case "user":
                username = item.value
            case "id":
                friendId = item.value
            default:
                break
            }
        }
        
        if let referralCode = referralCode {
            return InviteLinkData(type: .referral, referralCode: referralCode, username: username)
        } else if let friendId = friendId {
            return InviteLinkData(type: .friend, friendId: friendId, username: username)
        }
        
        return nil
    }
}

struct InviteLinkData {
    enum LinkType {
        case referral
        case friend
    }
    
    let type: LinkType
    let referralCode: String?
    let friendId: String?
    let username: String?
    
    init(type: LinkType, referralCode: String? = nil, friendId: String? = nil, username: String? = nil) {
        self.type = type
        self.referralCode = referralCode
        self.friendId = friendId
        self.username = username
    }
}

// Extension pour SwiftUI
extension InviteLinkBuilder {
    func shareInviteLinkSwiftUI(for user: User) {
        let inviteLink = generateInviteLink(for: user)
        let shareText = """
        Rejoins-moi sur CasinoX ! 🎰
        
        Utilise mon code de parrainage : \(user.referralCode)
        
        \(inviteLink)
        
        #CasinoX #JeuxCasino
        """
        
        // Copier dans le presse-papiers
        UIPasteboard.general.string = shareText
        
        // Feedback haptique
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}
