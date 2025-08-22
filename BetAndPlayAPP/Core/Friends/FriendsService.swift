import Foundation
import Combine

class FriendsService: ObservableObject {
    static let shared = FriendsService()
    
    @Published var friends: [Friend] = []
    @Published var pendingInvites: [FriendInvite] = []
    @Published var sentInvites: [FriendInvite] = []
    
    var pendingInvitations: [FriendInvite] {
        return pendingInvites
    }
    
    private let userDefaults = UserDefaults.standard
    private let friendsKey = "user_friends"
    private let pendingInvitesKey = "pending_invites"
    private let sentInvitesKey = "sent_invites"
    
    private init() {
        loadData()
    }
    
    func addFriend(_ friend: Friend) {
        friends.append(friend)
        saveData()
    }
    
    func removeFriend(_ friendId: String) {
        friends.removeAll { $0.id == friendId }
        saveData()
    }
    
    func sendInvite(to userId: String, username: String) {
        let invite = FriendInvite(
            id: UUID().uuidString,
            fromUserId: AuthStore.shared.currentUser?.id ?? "",
            fromUsername: AuthStore.shared.currentUser?.username ?? "",
            toUserId: userId,
            toUsername: username,
            status: .pending,
            date: Date()
        )
        
        sentInvites.append(invite)
        saveData()
    }
    
    func acceptInvite(_ inviteId: String) {
        guard let inviteIndex = pendingInvites.firstIndex(where: { $0.id == inviteId }) else { return }
        
        let invite = pendingInvites[inviteIndex]
        pendingInvites.remove(at: inviteIndex)
        
        // Ajouter l'ami
        let friend = Friend(
            id: invite.fromUserId,
            username: invite.fromUsername,
            avatarId: Int.random(in: 1...10),
            isOnline: Bool.random(),
            lastSeen: Date(),
            level: Int.random(in: 1...50),
            currentGame: nil,
            isVIP: false
        )
        
        addFriend(friend)
        
        // Mettre à jour le statut de l'invitation
        if let sentIndex = sentInvites.firstIndex(where: { $0.id == inviteId }) {
            sentInvites[sentIndex].status = .accepted
        }
        
        saveData()
    }
    
    func declineInvite(_ inviteId: String) {
        pendingInvites.removeAll { $0.id == inviteId }
        
        // Mettre à jour le statut de l'invitation
        if let sentIndex = sentInvites.firstIndex(where: { $0.id == inviteId }) {
            sentInvites[sentIndex].status = .declined
        }
        
        saveData()
    }
    
    func searchUsers(query: String) -> [UserSearchResult] {
        // Simuler une recherche d'utilisateurs
        let mockUsers = [
            UserSearchResult(id: "1", username: "Player1", avatarId: 1, level: 15),
            UserSearchResult(id: "2", username: "Player2", avatarId: 2, level: 23),
            UserSearchResult(id: "3", username: "Player3", avatarId: 3, level: 8),
            UserSearchResult(id: "4", username: "Player4", avatarId: 4, level: 31),
            UserSearchResult(id: "5", username: "Player5", avatarId: 5, level: 12)
        ]
        
        return mockUsers.filter { $0.username.lowercased().contains(query.lowercased()) }
    }
    
    func isFriend(_ userId: String) -> Bool {
        return friends.contains { $0.id == userId }
    }
    
    func hasPendingInvite(from userId: String) -> Bool {
        return pendingInvites.contains { $0.fromUserId == userId }
    }
    
    func hasSentInvite(to userId: String) -> Bool {
        return sentInvites.contains { $0.toUserId == userId && $0.status == .pending }
    }
    
    func acceptInvitation(_ invitationId: String) {
        if let index = pendingInvites.firstIndex(where: { $0.id == invitationId }) {
            var invitation = pendingInvites[index]
            invitation.status = .accepted
            pendingInvites.remove(at: index)
            
            // Ajouter comme ami
            let friend = Friend(
                id: invitation.fromUserId,
                username: invitation.fromUsername,
                avatarId: 1, // Avatar par défaut
                isOnline: false,
                lastSeen: Date(),
                level: 1,
                currentGame: nil,
                isVIP: false
            )
            addFriend(friend)
        }
    }
    
    func declineInvitation(_ invitationId: String) {
        if let index = pendingInvites.firstIndex(where: { $0.id == invitationId }) {
            pendingInvites[index].status = .declined
            pendingInvites.remove(at: index)
            saveData()
        }
    }
    
    // MARK: - Persistance
    
    private func saveData() {
        if let friendsData = try? JSONEncoder().encode(friends) {
            userDefaults.set(friendsData, forKey: friendsKey)
        }
        
        if let pendingData = try? JSONEncoder().encode(pendingInvites) {
            userDefaults.set(pendingData, forKey: pendingInvitesKey)
        }
        
        if let sentData = try? JSONEncoder().encode(sentInvites) {
            userDefaults.set(sentData, forKey: sentInvitesKey)
        }
    }
    
    private func loadData() {
        if let friendsData = userDefaults.data(forKey: friendsKey),
           let loadedFriends = try? JSONDecoder().decode([Friend].self, from: friendsData) {
            friends = loadedFriends
        }
        
        if let pendingData = userDefaults.data(forKey: pendingInvitesKey),
           let loadedPending = try? JSONDecoder().decode([FriendInvite].self, from: pendingData) {
            pendingInvites = loadedPending
        }
        
        if let sentData = userDefaults.data(forKey: sentInvitesKey),
           let loadedSent = try? JSONDecoder().decode([FriendInvite].self, from: sentData) {
            sentInvites = loadedSent
        }
    }
}

struct Friend: Identifiable, Codable {
    let id: String
    let username: String
    let avatarId: Int
    var isOnline: Bool
    var lastSeen: Date
    let level: Int
    var currentGame: GameType?
    var isVIP: Bool
    
    var avatarImage: String {
        return "avatar_\(avatarId)"
    }
    
    var statusText: String {
        if isOnline {
            return "En ligne"
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            return "Vu \(formatter.localizedString(for: lastSeen, relativeTo: Date()))"
        }
    }
}

struct FriendInvite: Identifiable, Codable {
    let id: String
    let fromUserId: String
    let fromUsername: String
    let toUserId: String
    let toUsername: String
    var status: InviteStatus
    let date: Date
    
    enum InviteStatus: String, Codable {
        case pending = "pending"
        case accepted = "accepted"
        case declined = "declined"
        
        var displayName: String {
            switch self {
            case .pending: return "En attente"
            case .accepted: return "Acceptée"
            case .declined: return "Refusée"
            }
        }
    }
}

struct UserSearchResult: Identifiable {
    let id: String
    let username: String
    let avatarId: Int
    let level: Int
    
    var avatarImage: String {
        return "avatar_\(avatarId)"
    }
}
