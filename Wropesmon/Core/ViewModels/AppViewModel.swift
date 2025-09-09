import SwiftUI
import Combine

enum Tab {
    case home
    case achievements
    case quiz
    case predictions
    case profile
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .achievements:
            return "trophy.fill"
        case .quiz:
            return "questionmark.circle.fill"
        case .predictions:
            return "figure.run"
        case .profile:
            return "person.fill"
        }
    }
    var title: String {
    switch self {
    case .home:
    return "Home"
    case .achievements:
    return "Achievements"
    case .quiz:
    return "Quizzes"
    case .predictions:
    return "Training"
    case .profile:
    return "Profile"
    }
    }
}

class AppViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var showSplashScreen = true
    @Published var currentUser: User?
    @Published var profileImage: UIImage?
    @Published var achievements: [Achievement] = []
    
    private let storageService: StorageServiceProtocol
    private let analyticsService = AnalyticsService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring()) {
                self.showSplashScreen = false
            }
        }
        
        loadUser()
        loadAchievements()
    }
    
    func updateProfile(username: String) {
        guard var user = currentUser else { return }
        user.username = username
        currentUser = user
        
        do {
            try storageService.save(user, forKey: "current_user")
            analyticsService.logEvent(.achievementUnlocked(title: "Profile updated"))
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func updateProfileImage(_ image: UIImage) {
        profileImage = image
    }
    
    func checkAndUnlockAchievements() {
        guard let user = currentUser else { return }
        
        if user.statistics.totalQuizzes >= 5 {
            unlockAchievement(id: "quiz_master")
        }
        
        if user.statistics.totalWorkouts >= 10 {
            unlockAchievement(id: "workout_warrior")
        }
        
        if user.statistics.streakDays >= 7 {
            unlockAchievement(id: "weekly_streak")
        }
    }
    
    private func unlockAchievement(id: String) {
        guard let index = achievements.firstIndex(where: { $0.id == id }),
              !achievements[index].isUnlocked else { return }
        
        achievements[index].isUnlocked = true
        analyticsService.logEvent(.achievementUnlocked(title: achievements[index].title))
    }
    
    private func loadUser() {
        do {
            if let savedUser = try storageService.load(User.self, forKey: "current_user") {
                currentUser = savedUser
            } else {
                currentUser = User(
                    id: UUID().uuidString,
                    username: "Athlete",
                    email: "athlete@example.com",
                    fitnessLevel: .intermediate,
                    preferences: UserPreferences(
                        favoriteWorkoutTypes: [.cardio, .strength],
                        weeklyGoals: WeeklyGoals(
                            workoutCount: 3,
                            quizCount: 5,
                            learningMinutes: 60
                        ),
                        notificationsEnabled: true
                    ),
                    achievements: [],
                    statistics: UserStatistics(
                        totalWorkouts: 8,
                        totalQuizzes: 15,
                        correctAnswers: 45,
                        workoutMinutes: 240,
                        streakDays: 5
                    )
                )
            }
        } catch {
            print("Failed to load user: \(error)")
        }
    }
    
    private func loadAchievements() {
        achievements = [
            Achievement(
            id: "quiz_master",
            title: "Quiz Master",
            description: "Complete 5 quizzes",
            iconName: "star.fill",
            isUnlocked: false,
            unlockedDate: nil
            ),
            Achievement(
            id: "workout_warrior",
            title: "Workout Warrior",
            description: "Complete 10 workouts",
            iconName: "figure.walk",
            isUnlocked: false,
            unlockedDate: nil
            ),
            Achievement(
            id: "weekly_streak",
            title: "Weekly Streak",
            description: "Workout 7 days in a row",
            iconName: "flame.fill",
            isUnlocked: false,
            unlockedDate: nil
            )
            ]
    }
}
