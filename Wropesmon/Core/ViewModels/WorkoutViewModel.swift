import SwiftUI
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var currentWorkout: WorkoutPlan?
    @Published var currentExerciseIndex = 0
    @Published var isWorkoutActive = false
    @Published var exerciseTimeRemaining: TimeInterval?
    @Published var totalWorkoutTime: TimeInterval = 0
    @Published var showTip = false
    @Published var currentTip: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let coachService = CoachService.shared
    private let analyticsService = AnalyticsService.shared
    
    var currentExercise: Exercise? {
        guard let workout = currentWorkout,
              currentExerciseIndex < workout.exercises.count else { return nil }
        return workout.exercises[currentExerciseIndex]
    }
    
    var progress: Double {
        guard let workout = currentWorkout else { return 0 }
        return Double(currentExerciseIndex) / Double(workout.exercises.count)
    }
    
    func startWorkout(_ workout: WorkoutPlan) {
        currentWorkout = workout
        currentExerciseIndex = 0
        isWorkoutActive = true
        totalWorkoutTime = 0
        
        analyticsService.logEvent(.workoutStarted(type: workout.type.rawValue))
        startExercise()
    }
    
    func startExercise() {
        guard let exercise = currentExercise else { return }
        
        if let duration = exercise.duration {
            exerciseTimeRemaining = duration
            startExerciseTimer()
        }
        
        // Показываем случайный совет
        showRandomTip()
    }
    
    func nextExercise() {
        guard let workout = currentWorkout else { return }
        
        if currentExerciseIndex + 1 < workout.exercises.count {
            currentExerciseIndex += 1
            startExercise()
        } else {
            completeWorkout()
        }
    }
    
    func showRandomTip() {
        guard let exercise = currentExercise else { return }
        let tips = coachService.provideWorkoutTips(for: exercise)
        currentTip = tips.randomElement()
        showTip = true
        
        // Скрываем подсказку через 5 секунд
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.showTip = false
        }
    }
    
    private func completeWorkout() {
        isWorkoutActive = false
        guard let workout = currentWorkout else { return }
        
        analyticsService.logEvent(.workoutCompleted(
            type: workout.type.rawValue,
            duration: totalWorkoutTime
        ))
    }
    
    private func startExerciseTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                      var remaining = self.exerciseTimeRemaining else { return }
                
                remaining -= 1
                self.exerciseTimeRemaining = remaining
                self.totalWorkoutTime += 1
                
                if remaining <= 0 {
                    self.nextExercise()
                }
            }
            .store(in: &cancellables)
    }
}
