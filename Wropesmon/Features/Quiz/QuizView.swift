import SwiftUI

struct QuizView: View {
    let category: SportCategory
    @StateObject private var viewModel = QuizViewModel()
    @State private var cardRotation = false
    @State private var showOptions = false
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            if viewModel.quizCompleted {
                QuizCompletedView(score: viewModel.score,
                                totalPossible: viewModel.currentQuiz?.totalPoints ?? 0,
                                category: category)
            } else {
                VStack(spacing: 20) {
                    progressBar
                    categoryHeader
                    questionCard
                    answerOptions
                }
                .padding()
            }
        }
        .navigationTitle("\(category.rawValue) - Квиз")
        .onAppear {
            // Здесь будет загрузка квиза для выбранной категории
            loadQuizForCategory()
        }
    }
    
    private var categoryHeader: some View {
        HStack {
            Text(category.icon)
                .font(.system(size: 30))
            Text(category.rawValue)
                .font(.headline)
        }
        .padding(.vertical)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(height: 8)
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * viewModel.progress, height: 8)
                    .animation(.spring(), value: viewModel.progress)
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
        .padding(.horizontal)
    }
    
    private var questionCard: some View {
        VStack {
            if let question = viewModel.currentQuestion {
                Text(question.question)
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .cardFlip(isFront: cardRotation)
                
                if let imageURL = question.imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
        .onAppear {
            withAnimation(.spring().delay(0.3)) {
                showOptions = true
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
                            withAnimation {
                                viewModel.selectAnswer(index)
                            }
                        }
                    )
                    .slideTransition(isPresented: showOptions)
                    .disabled(viewModel.showAnswer)
                }
                
                if viewModel.showAnswer {
                    Text(question.explanation)
                        .font(.callout)
                        .padding()
                        .slideTransition(isPresented: viewModel.showAnswer, edge: .bottom)
                    
                    Button("Следующий вопрос") {
                        withAnimation {
                            cardRotation.toggle()
                            showOptions = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.nextQuestion()
                            showOptions = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .slideTransition(isPresented: viewModel.showAnswer, edge: .bottom)
                }
            }
        }
    }
    
    private func loadQuizForCategory() {
        // Здесь будет загрузка квиза для выбранной категории
        // Временный пример квиза:
        let quiz = Quiz(
            id: UUID().uuidString,
            category: category,
            difficulty: .medium,
            questions: [
                QuizQuestion(
                    id: UUID().uuidString,
                    question: "Пример вопроса для категории \(category.rawValue)?",
                    options: ["Вариант 1", "Вариант 2", "Вариант 3", "Вариант 4"],
                    correctAnswer: 0,
                    explanation: "Объяснение правильного ответа",
                    points: 10,
                    imageURL: nil
                )
            ],
            timeLimit: nil
        )
        viewModel.startQuiz(quiz)
    }
}

struct QuizCompletedView: View {
    let score: Int
    let totalPossible: Int
    let category: SportCategory
    
    var body: some View {
        VStack(spacing: 20) {
            Text(category.icon)
                .font(.system(size: 60))
                .pulseAnimation()
            
            Text("Поздравляем!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Вы набрали \(score) из \(totalPossible) очков")
                .font(.title2)
            
            Text("Категория: \(category.rawValue)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button("Вернуться к категориям") {
                // Действие для возврата к списку категорий
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
