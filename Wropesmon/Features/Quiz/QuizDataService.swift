import Foundation
class QuizDataService: ObservableObject {
    static let shared = QuizDataService()
    private var allQuizzes: [SportCategory: Quiz] = [:]
    
    func loadAllQuizzes() {
        guard let url = Bundle.main.url(forResource: "all_quizzes", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let allQuizzesJSON = try? JSONDecoder().decode(AllQuizzesJSON.self, from: data) else {
            print("Failed to load quizzes")
            return
        }
        
        for quizCategory in allQuizzesJSON.quizzes {
            guard let sportCategory = SportCategory.fromString(quizCategory.category) else {
                continue
            }
            
            let questions = quizCategory.questions.map { questionJSON in
                QuizQuestion(
                    id: questionJSON.id,
                    question: questionJSON.question,
                    options: questionJSON.options,
                    correctAnswer: questionJSON.correctAnswer,
                    explanation: questionJSON.explanation,
                    points: questionJSON.points,
                    imageName: questionJSON.imageName
                )
            }
            
            let quiz = Quiz(
                id: UUID().uuidString,
                category: sportCategory,
                difficulty: .medium,
                questions: questions,
                timeLimit: 120
            )
            
            allQuizzes[sportCategory] = quiz
        }
    }
    
    func getQuiz(for category: SportCategory) -> Quiz? {
        return allQuizzes[category]
    }
    
    func getAllCategoriesWithQuizzes() -> [SportCategory] {
        return Array(allQuizzes.keys)
    }
}
