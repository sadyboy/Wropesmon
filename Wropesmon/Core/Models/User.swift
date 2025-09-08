import Foundation

struct User: Codable, Identifiable {
    let id: String
    var username: String
    var email: String
    var fitnessLevel: FitnessLevel
    var preferences: UserPreferences
    var achievements: [Achievement]
    var statistics: UserStatistics
    
    enum FitnessLevel: String, Codable {
        case beginner
        case intermediate
        case advanced
    }
}

struct UserPreferences: Codable {
    var favoriteWorkoutTypes: [WorkoutType]
    var weeklyGoals: WeeklyGoals
    var notificationsEnabled: Bool
}

struct WeeklyGoals: Codable {
    var workoutCount: Int
    var quizCount: Int
    var learningMinutes: Int
}

struct UserStatistics: Codable {
    var totalWorkouts: Int
    var totalQuizzes: Int
    var correctAnswers: Int
    var workoutMinutes: Int
    var streakDays: Int
}

struct Achievement: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    var isUnlocked: Bool
    let unlockedDate: Date?
}
