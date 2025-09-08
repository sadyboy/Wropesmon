import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var showSplashScreen = true
    @Published var currentUser: User?
    
    private let storageService: StorageServiceProtocol
    private let analyticsService = AnalyticsService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
        
        // Имитация загрузки данных
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring()) {
                self.showSplashScreen = false
            }
        }
        
        loadUser()
    }
    
    private func loadUser() {
        // Временный пользователь для демонстрации
        currentUser = User(
            id: UUID().uuidString,
            username: "Спортсмен",
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
}

enum Tab {
    case home
    case quiz
    case predictions
    case profile
    
    var title: String {
        switch self {
        case .home: return "Главная"
        case .quiz: return "Квизы"
        case .predictions: return "Тренировки"
        case .profile: return "Профиль"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .quiz: return "questionmark.circle.fill"
        case .predictions: return "figure.run"
        case .profile: return "person.fill"
        }
    }
}