import SwiftUI

// MARK: - Main Quiz View
 struct QuizView: View {
    let category: SportCategory
    @StateObject private var viewModel = QuizViewModel()
    @State private var showStatistics = false
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            if isLoading {
                ProgressView("Loading quiz...")
                    .scaleEffect(1.5)
            } else if let error = errorMessage {
                errorView(message: error)
            } else if viewModel.quizCompleted {
                QuizCompletedView(
                    score: viewModel.score,
                    totalPossible: viewModel.currentQuiz?.totalPoints ?? 0,
                    category: category,
                    timeSpent: viewModel.timeSpent,
                    onSeeStats: { showStatistics = true }
                )
            } else {
                VStack(spacing: 20) {
                    headerSection
                    progressBar
                    questionCard
                    answerOptions
                    Spacer()
                }
                .padding()
            }
        }
        .sheet(isPresented: $showStatistics) {
            QuizStatisticsView(results: viewModel.getBestResults())
        }
        .navigationTitle("\(category.rawValue) - Quiz")
        .onAppear {
            loadQuizForCategory()
        }
    }
    
    private func loadQuizForCategory() {
        isLoading = true
        errorMessage = nil
        
        // Даем небольшую задержку для плавности
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let quiz = QuizDataService.shared.getQuiz(for: category) {
                viewModel.startQuiz(quiz)
                isLoading = false
            } else {
                errorMessage = "Quiz for category \(category.rawValue) not found"
                isLoading = false
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Loading Error")
           .font(.anton(.h2))
            .fontWeight(.bold)

            Text(message)
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()

            Button("Try Again") {
                loadQuizForCategory()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.3),
                Color.purple.opacity(0.3),
                Color.orange.opacity(0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var headerSection: some View {
        HStack {
            Text(category.icon)
                .font(.system(size: 36))
            
            VStack(alignment: .leading) {
                Text(category.rawValue)
                   .font(.anton(.h1))
                    .fontWeight(.bold)
                
                if let timeRemaining = viewModel.timeRemaining {
                    Text("Remaining: \(Int(timeRemaining))s")
                   .font(.anton(.subheadline))
                    .foregroundColor(.secondary)
                    }

                    Text("Score: \(viewModel.score)")
                   .font(.anton(.subheadline))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var progressBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Question \(viewModel.currentQuestionIndex + 1) from \(viewModel.currentQuiz?.questions.count ?? 0)")
               .font(.anton(.subheadline))
                .foregroundColor(.secondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: geometry.size.width * viewModel.progress, height: 8)
                        .animation(.spring(response: 0.6), value: viewModel.progress)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
        .padding(.horizontal)
    }
    
    private var questionCard: some View {
        VStack(spacing: 0) {
            if let question = viewModel.currentQuestion {
                // Картинка вопроса
                if let imageName = question.imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                        .padding()
                        .shadow(radius: 5)
                }
                
                // Текст вопроса
                Text(question.question)
                   .font(.anton(.h3))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .rotation3DEffect(
                        .degrees(viewModel.showAnswer ? 360 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .animation(.spring(response: 0.6), value: viewModel.showAnswer)
            }
        }
    }
    
    private var answerOptions: some View {
        VStack(spacing: 12) {
            if let question = viewModel.currentQuestion {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    AnswerOptionButton(
                        text: option,
                        isSelected: viewModel.selectedAnswer == index,
                        isCorrect: viewModel.showAnswer ? (index == question.correctAnswer) : nil,
                        action: {
                            if !viewModel.showAnswer {
                                viewModel.selectAnswer(index)
                            }
                        }
                    )
                    .scaleEffect(viewModel.showAnswer && index == question.correctAnswer ? 1.05 : 1.0)
                    .animation(.spring(response: 0.5), value: viewModel.showAnswer)
                }
                
                if viewModel.showAnswer {
                    VStack(spacing: 12) {
                        Text(viewModel.isAnswerCorrect == true ? "Correct! 🎉" : "Incorrect 😔")
                           .font(.anton(.h1))
                            .foregroundColor(viewModel.isAnswerCorrect == true ? .green : .red)
                        
                        Text(question.explanation)
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                viewModel.nextQuestion()
                            }
                        }) {
                            Text("Next question →")
                               .font(.anton(.h1))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        .padding(.top)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .padding()
    }
}

// MARK: - Completed View
struct QuizCompletedView: View {
    let score: Int
    let totalPossible: Int
    let category: SportCategory
    let timeSpent: TimeInterval
    let onSeeStats: () -> Void
    
    var percentage: Double {
        Double(score) / Double(totalPossible) * 100
    }
    
    var grade: String {
        switch percentage {
            case 90...100: return "Great! 🎯"
            case 70..<90: return "Good! 👍"
            case 50..<70: return "Not bad! 🙂"
            default: return "It could be better! 💪"
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            // Анимированная иконка
//            LottieView(name: percentage > 70 ? "confetti" : "try_again", loopMode: .playOnce)
                .frame(height: 150)
            
            VStack(spacing: 15) {
                Text(grade)
                    .font(.anton(.h1))
                    .fontWeight(.bold)
                    .foregroundColor(percentage > 70 ? .green : .orange)
                
                Text("\(score)/\(totalPossible) (\(Int(percentage))%)")
                   .font(.anton(.h2))
                    .fontWeight(.semibold)
                
                Text("Category: \(category.rawValue)")
               .font(.anton(.h1))
                .foregroundColor(.secondary)

                Text("Time: \(formatTime(timeSpent))")
               .font(.anton(.subheadline))
                .foregroundColor(.secondary)
                }

                VStack(spacing: 15) {
                Button(action: onSeeStats) {
                HStack {
                Image(systemName: "chart.bar.fill")
                Text("See statistics")
                    }
                   .font(.anton(.h1))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                
                Button(action: {
                    // Restart quiz
                }) {
                    Text("Go again")
                       .font(.anton(.h1))
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 20)
        .padding(30)
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Statistics View
struct QuizStatisticsView: View {
    let results: [QuizResult]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if results.isEmpty {
                        emptyStateView
                    } else {
                        overallStatsView
                        categoryStatsView
                        bestResultsView
                    }
                }
                .padding()
            }
            .navigationTitle("Quiz stats")
            .navigationBarTitleDisplayMode(.large)
            }
            }

            private var emptyStateView: some View {
            VStack(spacing: 20) {
            Image(systemName: "chart.bar.doc.horizontal")
            .font(.system(size: 60))
            .foregroundColor(.gray)

            Text("Stats are empty for now")
           .font(.anton(.h2))
            .fontWeight(.semibold)

            Text("Take a few quizzes to see your results here")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            }

            private var overallStatsView: some View {
            VStack(spacing: 15) {
            Text("General Statistics")
           .font(.anton(.h2))
            .fontWeight(.bold)

            HStack(spacing: 20) {
            StatCardse(
            title: "Quizzes Completed",
            value: "\(results.count)",
            icon: "checkmark.circle.fill",
            color: .green
            )

            StatCardse(
            title: "Average Result",
            value: "\(Int(averagePercentage))%",
            icon: "percent",
            color: .blue
            )
            }
            }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var categoryStatsView: some View {
        VStack(spacing: 15) {
            Text("By Category")
           .font(.anton(.h2))
            .fontWeight(.bold)

            ForEach(Array(Set(results.map { $0.category })), id: \.self) { category in
            CategoryStatRow(category: category, results: results)
            }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            }

            private var bestResultsView: some View {
            VStack(spacing: 15) {
            Text("Best results")
           .font(.anton(.h2))
            .fontWeight(.bold)
            
            ForEach(results.prefix(5)) { result in
                BestResultRow(result: result)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var averagePercentage: Double {
        guard !results.isEmpty else { return 0 }
        return results.reduce(0) { $0 + $1.percentage } / Double(results.count)
    }
}

// MARK: - Supporting Views
struct StatCardse: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
               .font(.anton(.h2))
                .foregroundColor(color)
            
            Text(value)
                .font(.anton(.h1))
                .fontWeight(.bold)
            
            Text(title)
                .font(.anton(.caption))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CategoryStatRow: View {
    let category: SportCategory
    let results: [QuizResult]
    
    var categoryResults: [QuizResult] {
        results.filter { $0.category == category }
    }
    
    var averageScore: Double {
        guard !categoryResults.isEmpty else { return 0 }
        return Double(categoryResults.reduce(0) { $0 + $1.score }) / Double(categoryResults.count)
    }
    
    var body: some View {
        HStack {
            Text(category.icon)
               .font(.anton(.h2))
            
            VStack(alignment: .leading) {
                Text(category.rawValue)
                   .font(.anton(.h1))
                
                Text("Completed: \(categoryResults.count) times")
                    .font(.anton(.caption))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(averageScore))")
               .font(.anton(.h3))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct BestResultRow: View {
    let result: QuizResult
    
    var body: some View {
        HStack {
            Text(result.category.icon)
               .font(.anton(.h2))
            
            VStack(alignment: .leading) {
                Text(result.category.rawValue)
                   .font(.anton(.h1))
                
                Text(result.completedAt, style: .date)
                    .font(.anton(.caption))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(result.score)/\(result.totalPossible)")
                   .font(.anton(.h3))
                    .fontWeight(.bold)
                    .foregroundColor(result.percentage > 70 ? .green : .orange)
                
                Text("\(Int(result.percentage))%")
                    .font(.anton(.caption))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

