import AVFoundation
import SwiftUI

class SfxManager: ObservableObject {
    static let shared = SfxManager()
    
    @Published var isMuted: Bool = false
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Erreur configuration audio: \(error)")
        }
    }
    
    private func preloadSounds() {
        let soundFiles = [
            "chip": "chip",
            "deal": "deal", 
            "shuffle": "shuffle",
            "roulette_spin": "roulette_spin",
            "win": "win",
            "lose": "lose",
            "click": "click"
        ]
        
        for (key, filename) in soundFiles {
            if let url = Bundle.main.url(forResource: filename, withExtension: "wav") {
                do {
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    audioPlayers[key] = player
                } catch {
                    print("Erreur chargement son \(filename): \(error)")
                }
            }
        }
    }
    
    func play(_ sound: SfxSound) {
        guard !isMuted else { return }
        
        if let player = audioPlayers[sound.rawValue] {
            player.currentTime = 0
            player.play()
        }
    }
    
    func stopAll() {
        audioPlayers.values.forEach { $0.stop() }
    }
}

enum SfxSound: String, CaseIterable {
    case chip = "chip"
    case deal = "deal"
    case shuffle = "shuffle"
    case rouletteSpin = "roulette_spin"
    case win = "win"
    case lose = "lose"
    case click = "click"
}

// Extension pour faciliter l'utilisation
extension View {
    func playSound(_ sound: SfxSound) {
        SfxManager.shared.play(sound)
    }
}
