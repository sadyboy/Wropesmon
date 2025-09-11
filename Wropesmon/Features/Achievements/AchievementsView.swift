import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            .padding()
        }
        .navigationTitle("Achievements")
        .onAppear {
            viewModel.checkAndUnlockAchievements()
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 40))
                .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                .opacity(achievement.isUnlocked ? 1 : 0.5)
            
            Text(achievement.title)
               .font(.anton(.h1))
               .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.anton(.caption))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(height: 180)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.4)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
        )
        .cornerRadius(15)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(achievement.isUnlocked ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }
}

