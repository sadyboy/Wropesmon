import SwiftUI
import Combine

// MARK: - ViewModel
class QuizViewModel: ObservableObject {
    @Published var currentQuiz: Quiz?
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int?
    @Published var score = 0
    @Published var showAnswer = false
    @Published var quizCompleted = false
    @Published var timeRemaining: TimeInterval?
    @Published var timeSpent: TimeInterval = 0
    @Published var isAnswerCorrect: Bool?
    
    private var timer: Timer?
    private var startTime: Date?
    private var quizResults: [QuizResult] = []
    
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
        timeSpent = 0
        startTime = Date()
        
        if let timeLimit = quiz.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        }
    }
    
    func selectAnswer(_ index: Int) {
        guard !showAnswer, let question = currentQuestion else { return }
        
        selectedAnswer = index
        showAnswer = true
        isAnswerCorrect = index == question.correctAnswer
        
        if isAnswerCorrect == true {
            score += question.points
            playSound(named: "correct")
        } else {
            playSound(named: "wrong")
        }
    }
    
    func nextQuestion() {
        guard let quiz = currentQuiz else { return }
        
        if currentQuestionIndex + 1 < quiz.questions.count {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showAnswer = false
            isAnswerCorrect = nil
        } else {
            completeQuiz()
        }
    }
    
    private func completeQuiz() {
        quizCompleted = true
        stopTimer()
        
        guard let quiz = currentQuiz, let startTime = startTime else { return }
        
        let result = QuizResult(
            quizId: quiz.id,
            category: quiz.category,
            score: score,
            totalPossible: quiz.totalPoints,
            completedAt: Date(),
            timeSpent: Date().timeIntervalSince(startTime)
        )
        
        quizResults.append(result)
        saveResults()
        playSound(named: "complete")
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let remaining = self.timeRemaining {
                if remaining > 0 {
                    self.timeRemaining = remaining - 1
                    self.timeSpent += 1
                } else {
                    self.completeQuiz()
                }
            } else {
                self.timeSpent += 1
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func saveResults() {
        if let encoded = try? JSONEncoder().encode(quizResults) {
            UserDefaults.standard.set(encoded, forKey: "quiz_results")
        }
    }
    
    func loadResults() {
        if let data = UserDefaults.standard.data(forKey: "quiz_results"),
           let results = try? JSONDecoder().decode([QuizResult].self, from: data) {
            quizResults = results
        }
    }
    
    func getBestResults() -> [QuizResult] {
        var bestResults: [SportCategory: QuizResult] = [:]
        
        for result in quizResults {
            if let currentBest = bestResults[result.category] {
                if result.score > currentBest.score {
                    bestResults[result.category] = result
                }
            } else {
                bestResults[result.category] = result
            }
        }
        
        return Array(bestResults.values).sorted { $0.score > $1.score }
    }
    
    private func playSound(named: String) {
    }
}
