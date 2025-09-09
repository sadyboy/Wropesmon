import Foundation

enum WorkoutType: String, Codable, CaseIterable {
    case cardio = "Cardio"
    case strength = "Power"
    case flexibility = "Flexibility"
    case sport = "Sport"
    case recovery = "Recovery"
    
    var description: String {
        switch self {
        case .cardio:
            return "Training to improve endurance and cardiovascular fitness"
        case .strength:
            return "Exercises to build strength and muscle mass"
        case .flexibility:
            return "Exercises to improve flexibility and mobility"
        case .sport:
            return "Sports training and game exercises"
        case .recovery:
            return "Light exercises for recovery"
        }
    }
    
    var icon: String {
        switch self {
        case .cardio:
            return "heart.circle.fill"
        case .strength:
            return "figure.strengthtraining"
        case .flexibility:
            return "figure.flexibility"
        case .sport:
            return "sportscourt.fill"
        case .recovery:
            return "bed.double.fill"
        }
    }
    
    var recommendedDuration: TimeInterval {
        switch self {
        case .cardio:
            return 1800
        case .strength:
            return 2700
        case .flexibility:
            return 1200
        case .sport:
            return 3600
        case .recovery:
            return 900
        }
    }
    
    var defaultCaloriesBurn: Int {
        switch self {
        case .cardio:
            return 300
        case .strength:
            return 250
        case .flexibility:
            return 150
        case .sport:
            return 400
        case .recovery:
            return 100
        }
    }
}
