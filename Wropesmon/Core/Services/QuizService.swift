import Foundation

class QuizService {
    static let shared = QuizService()
    
    func loadQuiz(for category: SportCategory) async throws -> Quiz {
        guard let url = Bundle.main.url(forResource: "\(category.rawValue.lowercased())_quiz", withExtension: "json") else {
            throw NSError(domain: "QuizService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Quiz file not found"])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(Quiz.self, from: data)
    }
}

