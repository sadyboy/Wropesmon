import Foundation

class CoachService {
    static let shared = CoachService()
    private let storageService: StorageServiceProtocol
    
    private init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    func generatePersonalizedWorkoutPlan(for user: User) -> WorkoutPlan {
        let exercises = recommendedExercises(for: user.fitnessLevel)
        
        return WorkoutPlan(
            id: UUID().uuidString,
            title: "Personal training plan",
            description: "A plan tailored specifically to your level",
            type: user.preferences.favoriteWorkoutTypes.first ?? .cardio,
            difficulty: difficultyForUser(user),
            duration: 3600,
            exercises: exercises,
            tips: generateTips(for: exercises),
            recommendedEquipment: recommendedEquipment(for: exercises)
        )
    }
    
    func provideWorkoutTips(for exercise: Exercise) -> [String] {
        var tips = exercise.tips
        
        tips.append("Watch your breathing while doing it")
        tips.append("Maintain good posture")
        
        return tips
    }
    
    func adjustWorkoutIntensity(plan: WorkoutPlan, userFeedback: Double) -> WorkoutPlan {
        var adjustedExercises = plan.exercises
        
        if userFeedback < 0.3 {
            adjustedExercises = adjustExercisesIntensity(exercises: adjustedExercises, decrease: true)
        } else if userFeedback > 0.7 {
            adjustedExercises = adjustExercisesIntensity(exercises: adjustedExercises, decrease: false)
        }
        
        return WorkoutPlan(
            id: UUID().uuidString,
            title: plan.title + " (Adjusted)",
            description: plan.description,
            type: plan.type,
            difficulty: plan.difficulty,
            duration: plan.duration,
            exercises: adjustedExercises,
            tips: plan.tips,
            recommendedEquipment: plan.recommendedEquipment
        )
    }
    
    private func recommendedExercises(for level: User.FitnessLevel) -> [Exercise] {
        return []
    }
    
    private func difficultyForUser(_ user: User) -> WorkoutDifficulty {
        switch user.fitnessLevel {
        case .beginner: return .beginner
        case .intermediate: return .intermediate
        case .advanced: return .advanced
        }
    }
    
    private func generateTips(for exercises: [Exercise]) -> [String] {
        var tips: [String] = []
        exercises.forEach { exercise in
            tips.append(contentsOf: exercise.tips)
        }
        return Array(Set(tips))
    }
    
    private func recommendedEquipment(for exercises: [Exercise]) -> [Equipment] {
        return []
    }
    
    private func adjustExercisesIntensity(exercises: [Exercise], decrease: Bool) -> [Exercise] {
        return exercises
    }
}
