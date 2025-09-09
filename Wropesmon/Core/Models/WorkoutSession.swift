import Foundation

struct WorkoutSession: Identifiable, Codable {
    let id: String
    let type: WorkoutType
    let exercises: [WorkoutExercise]
    let duration: TimeInterval
    let date: Date
    var isCompleted: Bool
    var caloriesBurned: Int?
}

struct WorkoutExercise: Identifiable, Codable {
    let id: String
    let name: String
    let sets: Int
    let reps: Int
    let duration: TimeInterval?
    let restBetweenSets: TimeInterval
    let description: String
    let videoURL: URL?
    let tips: [String]
    var isCompleted: Bool
    
    var formattedDuration: String {
        guard let duration = duration else { return "" }
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
