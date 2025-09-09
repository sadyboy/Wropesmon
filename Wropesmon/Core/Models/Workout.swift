import Foundation


struct WorkoutPlan: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let type: WorkoutType
    let difficulty: WorkoutDifficulty
    let duration: TimeInterval
    let exercises: [Exercise]
    let tips: [String]
    let recommendedEquipment: [Equipment]
}

struct Exercise: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let muscleGroups: [MuscleGroup]
    let duration: TimeInterval?
    let repetitions: Int?
    let sets: Int?
    let restBetweenSets: TimeInterval
    let videoURL: URL?
    let tips: [String]
}

enum WorkoutDifficulty: String, Codable {
    case beginner
    case intermediate
    case advanced
    
    var recommendedExperience: String {
        switch self {
            case .beginner: return "0-3 months"
            case .intermediate: return "3-12 months"
            case .advanced: return "More than 1 year"
        }
    }
}

enum MuscleGroup: String, Codable {
    case legs
    case core
    case chest
    case back
    case shoulders
    case arms
}

struct Equipment: Codable {
    let name: String
    let isRequired: Bool
}
