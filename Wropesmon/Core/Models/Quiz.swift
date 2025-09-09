import Foundation

struct AllQuizzesJSON: Codable {
    let quizzes: [QuizCategoryJSON]
}

struct QuizCategoryJSON: Codable {
    let category: String
    let questions: [QuizQuestionJSON]
}

struct QuizQuestionJSON: Codable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let points: Int
    let imageName: String?
}

struct Quiz: Codable, Identifiable {
    let id: String
    let category: SportCategory
    let difficulty: QuizDifficulty
    let questions: [QuizQuestion]
    let timeLimit: TimeInterval?
    
    var totalPoints: Int {
        questions.reduce(0) { $0 + $1.points }
    }
}

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let points: Int
    let imageName: String?
}

enum QuizDifficulty: String, Codable {
    case easy, medium, hard
    
    var multiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        }
    }
}

struct QuizResult: Codable, Identifiable {
    let id = UUID()
    let quizId: String
    let category: SportCategory
    let score: Int
    let totalPossible: Int
    let completedAt: Date
    let timeSpent: TimeInterval
    
    var percentage: Double {
        Double(score) / Double(totalPossible) * 100
    }
    
    var grade: String {
    switch percentage {
    case 90...100: return "Excellent! 🎯"
    case 70..<90: return "Good! 👍"
    case 50..<70: return "Not bad! 🙂"
    default: return "It could be better! 💪"
    }
    }
    }
