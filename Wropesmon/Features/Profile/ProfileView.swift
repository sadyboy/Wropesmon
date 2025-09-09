import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showingEditProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                statisticsSection
                achievementsSection
            }
            .padding()
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $showingEditProfile) {
            ProfileEditView()
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 15) {
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            
            if let user = viewModel.currentUser {
                Text(user.username)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Level: \(user.fitnessLevel.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button("Edit profile") {
                showingEditProfile = true
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Statistics")
            .font(.title2)
            .fontWeight(.bold)

            if let user = viewModel.currentUser {
            LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
            ], spacing: 15) {
            StatCard(title: "Quizzes", value: "\(user.statistics.totalQuizzes)", icon: "questionmark.circle.fill")
            StatCard(title: "Workouts", value: "\(user.statistics.totalWorkouts)", icon: "figure.run")
            StatCard(title: "Correct Answers", value: "\(user.statistics.correctAnswers)", icon: "checkmark.circle.fill")
            StatCard(title: "Workout Minutes", value: "\(user.statistics.workoutMinutes)", icon: "clock.fill")
            }
            }
            }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
            Text("Latest Achievements")
            .font(.title2)
            .fontWeight(.bold)

            Spacer()

            NavigationLink("All") {
            AchievementsView()
            }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.achievements.prefix(3)) { achievement in
                        AchievementCard(achievement: achievement)
                            .frame(width: 160)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
