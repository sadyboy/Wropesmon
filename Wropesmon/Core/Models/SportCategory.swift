import Foundation

enum SportCategory: String, Codable, CaseIterable {
    case football = "Футбол"
    case basketball = "Баскетбол"
    case volleyball = "Волейбол"
    case tennis = "Теннис"
    case swimming = "Плавание"
    case athletics = "Лёгкая атлетика"
    case gymnastics = "Гимнастика"
    case boxing = "Бокс"
    case martialArts = "Боевые искусства"
    case yoga = "Йога"
    
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
            return "Изучите правила, тактики и историю футбола"
        case .basketball:
            return "Узнайте о техниках, стратегиях и звездах баскетбола"
        case .volleyball:
            return "Погрузитесь в мир волейбола и его особенности"
        case .tennis:
            return "Освойте основы тенниса и его правила"
        case .swimming:
            return "Изучите различные стили плавания и техники"
        case .athletics:
            return "Узнайте о различных видах легкой атлетики"
        case .gymnastics:
            return "Познакомьтесь с видами гимнастики и упражнениями"
        case .boxing:
            return "Изучите технику бокса и правила соревнований"
        case .martialArts:
            return "Узнайте о различных боевых искусствах и их философии"
        case .yoga:
            return "Освойте асаны и принципы йоги"
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
