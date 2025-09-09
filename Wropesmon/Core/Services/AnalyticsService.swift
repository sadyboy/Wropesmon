import Foundation

enum AnalyticsEvent {
    case quizStarted(category: String)
    case quizCompleted(category: String, score: Int)
    case workoutStarted(type: String)
    case workoutCompleted(type: String, duration: TimeInterval)
    case achievementUnlocked(title: String)
    
    var name: String {
        switch self {
        case .quizStarted: return "quiz_started"
        case .quizCompleted: return "quiz_completed"
        case .workoutStarted: return "workout_started"
        case .workoutCompleted: return "workout_completed"
        case .achievementUnlocked: return "achievement_unlocked"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .quizStarted(let category):
            return ["category": category]
        case .quizCompleted(let category, let score):
            return ["category": category, "score": score]
        case .workoutStarted(let type):
            return ["workout_type": type]
        case .workoutCompleted(let type, let duration):
            return ["workout_type": type, "duration": duration]
        case .achievementUnlocked(let title):
            return ["achievement": title]
        }
    }
}

class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func logEvent(_ event: AnalyticsEvent) {
        print("Analytics Event: \(event.name)")
        print("Parameters: \(event.parameters)")
    }
}
