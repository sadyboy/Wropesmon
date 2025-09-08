import Foundation

class CoachService {
    static let shared = CoachService()
    private let storageService: StorageServiceProtocol
    
    private init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    func generatePersonalizedWorkoutPlan(for user: User) -> WorkoutPlan {
        // Создание персонализированного плана на основе уровня пользователя
        let exercises = recommendedExercises(for: user.fitnessLevel)
        
        return WorkoutPlan(
            id: UUID().uuidString,
            title: "Персональный план тренировок",
            description: "План, созданный специально для вашего уровня",
            type: user.preferences.favoriteWorkoutTypes.first ?? .cardio,
            difficulty: difficultyForUser(user),
            duration: 3600, // 1 час
            exercises: exercises,
            tips: generateTips(for: exercises),
            recommendedEquipment: recommendedEquipment(for: exercises)
        )
    }
    
    func provideWorkoutTips(for exercise: Exercise) -> [String] {
        var tips = exercise.tips
        
        // Добавляем общие рекомендации по технике
        tips.append("Следите за дыханием во время выполнения")
        tips.append("Поддерживайте правильную осанку")
        
        return tips
    }
    
    func adjustWorkoutIntensity(plan: WorkoutPlan, userFeedback: Double) -> WorkoutPlan {
        // Корректировка плана на основе обратной связи
        var adjustedExercises = plan.exercises
        
        if userFeedback < 0.3 { // Слишком сложно
            adjustedExercises = adjustExercisesIntensity(exercises: adjustedExercises, decrease: true)
        } else if userFeedback > 0.7 { // Слишком легко
            adjustedExercises = adjustExercisesIntensity(exercises: adjustedExercises, decrease: false)
        }
        
        return WorkoutPlan(
            id: UUID().uuidString,
            title: plan.title + " (Скорректированный)",
            description: plan.description,
            type: plan.type,
            difficulty: plan.difficulty,
            duration: plan.duration,
            exercises: adjustedExercises,
            tips: plan.tips,
            recommendedEquipment: plan.recommendedEquipment
        )
    }
    
    // Вспомогательные методы
    private func recommendedExercises(for level: User.FitnessLevel) -> [Exercise] {
        // Здесь будет логика подбора упражнений
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
        return Array(Set(tips)) // Убираем дубликаты
    }
    
    private func recommendedEquipment(for exercises: [Exercise]) -> [Equipment] {
        // Логика подбора оборудования
        return []
    }
    
    private func adjustExercisesIntensity(exercises: [Exercise], decrease: Bool) -> [Exercise] {
        // Логика корректировки интенсивности
        return exercises
    }
}
