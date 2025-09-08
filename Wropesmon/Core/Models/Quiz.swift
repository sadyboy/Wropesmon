import Foundation

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
    let imageURL: URL?
}

enum QuizDifficulty: String, Codable {
    case easy
    case medium
    case hard
    
    var multiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 2.0
        }
    }
}
