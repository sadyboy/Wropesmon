import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentQuiz: Quiz?
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int?
    @Published var score = 0
    @Published var showAnswer = false
    @Published var quizCompleted = false
    @Published var timeRemaining: TimeInterval?
    
    private var cancellables = Set<AnyCancellable>()
    private let analyticsService = AnalyticsService.shared
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol = StorageService()) {
        self.storageService = storageService
    }
    
    var currentQuestion: QuizQuestion? {
        guard let quiz = currentQuiz,
              currentQuestionIndex < quiz.questions.count else { return nil }
        return quiz.questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard let quiz = currentQuiz else { return 0 }
        return Double(currentQuestionIndex) / Double(quiz.questions.count)
    }
    
    func startQuiz(_ quiz: Quiz) {
        currentQuiz = quiz
        currentQuestionIndex = 0
        score = 0
        quizCompleted = false
        selectedAnswer = nil
        showAnswer = false
        
        analyticsService.logEvent(.quizStarted(category: quiz.category.rawValue))
        
        if let timeLimit = quiz.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        }
    }
    
    func selectAnswer(_ index: Int) {
        guard !showAnswer else { return }
        selectedAnswer = index
        showAnswer = true
        
        if let question = currentQuestion, index == question.correctAnswer {
            score += question.points
        }
    }
    
    func nextQuestion() {
        guard let quiz = currentQuiz else { return }
        
        if currentQuestionIndex + 1 < quiz.questions.count {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showAnswer = false
        } else {
            completeQuiz()
        }
    }
    
    private func completeQuiz() {
        quizCompleted = true
        guard let quiz = currentQuiz else { return }
        
        analyticsService.logEvent(.quizCompleted(
            category: quiz.category.rawValue,
            score: score
        ))
        
        // Сохраняем результат
        do {
            let result = QuizResult(
                quizId: quiz.id,
                score: score,
                totalPossible: quiz.totalPoints,
                completedAt: Date()
            )
            try storageService.save(result, forKey: "quiz_result_\(quiz.id)")
        } catch {
            print("Failed to save quiz result: \(error)")
        }
    }
    
    private func startTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                      var remaining = self.timeRemaining else { return }
                
                remaining -= 1
                self.timeRemaining = remaining
                
                if remaining <= 0 {
                    self.completeQuiz()
                }
            }
            .store(in: &cancellables)
    }
}

struct QuizResult: Codable {
    let quizId: String
    let score: Int
    let totalPossible: Int
    let completedAt: Date
}
