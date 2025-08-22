import SwiftUI

struct ModernAvatarButton: View {
    let avatar: AvatarData
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Avatar avec indicateur de rareté
                ZStack {
                    // Cercle de fond avec couleur de rareté
                    Circle()
                        .fill(avatar.rarity.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    // Cercle principal de l'avatar
                    Circle()
                        .fill(avatar.color)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: avatar.iconName)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        )
                    
                    // Indicateur premium
                    if avatar.isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.gold)
                                    .background(
                                        Circle()
                                            .fill(Color.black.opacity(0.8))
                                            .frame(width: 16, height: 16)
                                    )
                            }
                            Spacer()
                        }
                        .frame(width: 60, height: 60)
                    }
                    
                    // Bordure de sélection
                    if isSelected {
                        Circle()
                            .stroke(AppColors.accent, lineWidth: 3)
                            .frame(width: 60, height: 60)
                    }
                }
                
                // Nom de l'avatar
                Text(avatar.name)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.text)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 24)
                
                // Indicateur de rareté
                Text(avatar.rarity.displayName)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(avatar.rarity.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(avatar.rarity.color.opacity(0.1))
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct AvatarSelectionGrid: View {
    @Binding var selectedAvatarId: Int
    let avatars: [AvatarData]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 16) {
            ForEach(avatars) { avatar in
                ModernAvatarButton(
                    avatar: avatar,
                    isSelected: selectedAvatarId == avatar.id
                ) {
                    selectedAvatarId = avatar.id
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct AvatarRarityFilter: View {
    @Binding var selectedRarity: AvatarData.AvatarRarity?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Bouton "Tous"
                FilterChip(
                    title: "Tous",
                    isSelected: selectedRarity == nil,
                    color: AppColors.accent
                ) {
                    selectedRarity = nil
                }
                
                // Filtres par rareté
                ForEach(AvatarData.AvatarRarity.allCases, id: \.self) { rarity in
                    FilterChip(
                        title: rarity.displayName,
                        isSelected: selectedRarity == rarity,
                        color: rarity.color
                    ) {
                        selectedRarity = rarity
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? color : color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        ModernAvatarButton(
            avatar: AppAvatars.allAvatars[0],
            isSelected: true
        ) {}
        
        ModernAvatarButton(
            avatar: AppAvatars.allAvatars[20],
            isSelected: false
        ) {}
        
        AvatarRarityFilter(selectedRarity: .constant(nil))
    }
    .padding()
    .background(Color.black)
}
