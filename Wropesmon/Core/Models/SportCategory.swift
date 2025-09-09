import Foundation

enum SportCategory: String, Codable, CaseIterable {
case football = "Football"
case basketball = "Basketball"
case volleyball = "Volleyball"
case tennis = "Tennis"
case swimming = "Swimming"
case athletics = "Athletics"
case gymnastics = "Gymnastics"
case boxing = "Boxing"
case martialArts = "Martial Arts"
case yoga = "Yoga"
    
    var icon: String {
        switch self {
        case .football: return "⚽️"
        case .basketball: return "🏀"
        case .volleyball: return "🏐"
        case .tennis: return "🎾"
        case .swimming: return "🏊‍♂️"
        case .athletics: return "🏃‍♂️"
        case .gymnastics: return "🤸‍♂️"
        case .boxing: return "🥊"
        case .martialArts: return "🥋"
        case .yoga: return "🧘‍♂️"
        }
    }
    
    var description: String {
    switch self {
    case .football:
    return "Learn the rules, tactics, and history of football"
    case .basketball:
    return "Learn about basketball techniques, strategies, and stars"
    case .volleyball:
    return "Dive into the world of volleyball and its intricacies"
    case .tennis:
    return "Learn the basics of tennis and its rules"
    case .swimming:
    return "Learn about different swimming styles and techniques"
    case .athletics:
    return "Learn about different types of athletics"
    case .gymnastics:
    return "Learn about types of gymnastics and exercises"
    case .boxing:
    return "Learn about boxing techniques and competition rules"
    case .martialArts:
    return "Learn about different martial arts and their philosophies"
    case .yoga:
    return "Learn about yoga asanas and principles"
    }
    }
    
    var recommendedWorkouts: [WorkoutType] {
        switch self {
        case .football, .basketball, .volleyball:
            return [.cardio, .strength]
        case .tennis:
            return [.strength, .flexibility]
        case .swimming:
            return [.cardio, .recovery]
        case .athletics:
            return [.cardio, .strength, .flexibility]
        case .gymnastics:
            return [.flexibility, .strength]
        case .boxing, .martialArts:
            return [.strength, .cardio]
        case .yoga:
            return [.flexibility, .recovery]
        }
    }
    
    var difficultyLevels: [QuizDifficulty] {
        [.easy, .medium, .hard]
    }
}
extension SportCategory {
    static func fromString(_ string: String) -> SportCategory? {
        let mapping: [String: SportCategory] = [
            "football": .football,
            "basketball": .basketball,
            "volleyball": .volleyball,
            "tennis": .tennis,
            "swimming": .swimming,
            "athletics": .athletics,
            "gymnastics": .gymnastics,
            "boxing": .boxing,
            "martialArts": .martialArts,
            "yoga": .yoga
        ]
        return mapping[string.lowercased()]
    }
    
    var stringValue: String {
        switch self {
        case .football: return "football"
        case .basketball: return "basketball"
        case .volleyball: return "volleyball"
        case .tennis: return "tennis"
        case .swimming: return "swimming"
        case .athletics: return "athletics"
        case .gymnastics: return "gymnastics"
        case .boxing: return "boxing"
        case .martialArts: return "martialArts"
        case .yoga: return "yoga"
        }
    }
}
