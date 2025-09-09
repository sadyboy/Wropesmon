import SwiftUI

struct WorkoutListView: View {
    @State private var selectedWorkout: WorkoutSession?
    @State private var showingWorkoutDetail = false
    @State private var searchText = ""
    @State private var selectedCategory: WorkoutType?
    @State private var showingFilters = false
    @State private var animateCards = false
    @State private var showMotivationalQuote = false
    @State private var currentQuoteIndex = 0
    
    private let motivationalQuotes = [
    "Strength is not in muscles, but in will! 💪",
    "Every workout brings you closer to your goal! 🏆",
    "Today's work is tomorrow's result! ⚡",
    "Don't give up, you are stronger than you think! 🔥",
    "Progress is measured not in kilograms, but in perseverance! 📈"
    ]
    
    var filteredWorkouts: [WorkoutSession] {
        let allWorkouts = WorkoutType.allCases.flatMap { workoutsFor(type: $0) }
        
        return allWorkouts.filter { workout in
            let matchesSearch = searchText.isEmpty ||
                              workout.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                              workout.exercises.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            
            let matchesCategory = selectedCategory == nil || workout.type == selectedCategory
            
            return matchesSearch && matchesCategory
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон с градиентом
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Мотивационная цитата
                        motivationalQuoteSection
                        
                        // Поиск и фильтры
                        searchAndFilterSection
                        
                        // Статистика
                        quickStatsSection
                        
                        // Список тренировок
                        if filteredWorkouts.isEmpty {
                            emptyStateView
                        } else {
                            workoutsGridSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Training")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
            .sheet(isPresented: $showingWorkoutDetail) {
                if let workout = selectedWorkout {
                    WorkoutDetailView(workout: workout)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                    animateCards = true
                }
                
                // Анимация цитат
                startQuoteAnimation()
            }
        }
    }
    
    // MARK: - Мотивационная цитата
    private var motivationalQuoteSection: some View {
        VStack {
            if showMotivationalQuote {
                Text(motivationalQuotes[currentQuoteIndex])
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.8), value: showMotivationalQuote)
    }
    
    // MARK: - Поиск и фильтры
    private var searchAndFilterSection: some View {
        VStack(spacing: 15) {
            // Поле поиска
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Searching for workouts...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([nil] + WorkoutType.allCases, id: \.self) { category in
                        CategoryPill(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    // MARK: - Быстрая статистика
    private var quickStatsSection: some View {
    HStack(spacing: 15) {
    StatCards(
    icon: "clock.fill",
    value: "\(filteredWorkouts.count)",
    title: "Available",
    color: .blue
    )

    StatCards(
    icon: "flame.fill",
    value: "\(filteredWorkouts.reduce(0) { $0 + ($1.caloriesBurned ?? 0) })",
    title: "Kcal total",
    color: .orange
    )

    StatCards(
    icon: "figure.walk",
    value: "\(filteredWorkouts.reduce(0) { $0 + $1.exercises.count })",
    title: "Exercises",
    color: .green
    )
    }
    }
    
    // MARK: - Сетка тренировок
    private var workoutsGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(Array(filteredWorkouts.enumerated()), id: \.element.id) { index, workout in
                WorkoutCard(workout: workout)
                    .scaleEffect(animateCards ? 1 : 0.8)
                    .opacity(animateCards ? 1 : 0)
                    .rotationEffect(.degrees(animateCards ? 0 : 5))
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateCards
                    )
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7)) {
                            selectedWorkout = workout
                            showingWorkoutDetail = true
                        }
                    }
            }
        }
    }
    
    // MARK: - Пустое состояние
    private var emptyStateView: some View {
    VStack(spacing: 20) {
    Image(systemName: "magnifyingglass")
    .font(.system(size: 60))
    .foregroundColor(.secondary)
    .padding()
    .background(Circle().fill(Color.white))

    Text("Nothing found")
    .font(.title3)
    .fontWeight(.semibold)

    Text("Try changing search parameters or choosing another category")
    .font(.subheadline)
    .foregroundColor(.secondary)
    .multilineTextAlignment(.center)

    Button("Reset filters") {
    withAnimation {
    searchText = ""
    selectedCategory = nil
    }
    }
    .buttonStyle(PrimaryButtonStyle())
    }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Кнопка фильтра
    private var filterButton: some View {
        Button {
            withAnimation(.spring()) {
                showingFilters.toggle()
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle\(showingFilters ? ".fill" : "")")
                .font(.title2)
                .foregroundColor(.blue)
        }
    }
    
    // MARK: - Helper Methods
    private func startQuoteAnimation() {
        showMotivationalQuote = true
        
        // Меняем цитату каждые 8 секунд
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.8)) {
                showMotivationalQuote = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                currentQuoteIndex = (currentQuoteIndex + 1) % motivationalQuotes.count
                withAnimation(.easeInOut(duration: 0.8)) {
                    showMotivationalQuote = true
                }
            }
        }
    }
    
    private func workoutsFor(type: WorkoutType) -> [WorkoutSession] {
        [
            WorkoutSession(
                id: UUID().uuidString,
                type: type,
                exercises: generateExercises(for: type),
                duration: [1800, 2400, 3000].randomElement()!,
                date: Date(),
                isCompleted: false,
                caloriesBurned: Int.random(in: 150...400)
            ),
            WorkoutSession(
                id: UUID().uuidString,
                type: type,
                exercises: generateExercises(for: type),
                duration: [1800, 2400, 3000].randomElement()!,
                date: Date(),
                isCompleted: false,
                caloriesBurned: Int.random(in: 150...400)
            )
        ]
    }
    
    private func generateExercises(for type: WorkoutType) -> [WorkoutExercise] {
    switch type {
    case .cardio:
    return [
    WorkoutExercise(
    id: UUID().uuidString,
    name: "Running",
    sets: 1,
    reps: 1,
    duration: 900,
    restBetweenSets: 60,
    description: "Running at a moderate pace to develop endurance",
    videoURL: nil,
    tips: ["Watch your breathing", "Keep a good posture"],
    isCompleted: false
    )
    ]
    case .strength:
    return [
    WorkoutExercise(
    id: UUID().uuidString,
    name: "Push-ups",
    sets: 3,
    reps: 15,
    duration: nil,
    restBetweenSets: 60,
    description: "Classic push-ups",
    videoURL: nil,
    tips: ["Keep your elbows close to your body", "Get down to parallel"],
    isCompleted: false
    )
    ]
    case .flexibility:
    return [
    WorkoutExercise(
    id: UUID().uuidString,
    name: "Yoga",
    sets: 1,
    reps: 1,
    duration: 1800,
    restBetweenSets: 0,
    description: "Flexibility workout",
    videoURL: nil,
    tips: ["Breathe deeply", "Don't overexert yourself"],
    isCompleted: false
    )
    ]
    case .recovery:
    return [
    WorkoutExercise(
    id: UUID().uuidString,
    name: "Meditation",
    sets: 1,
    reps: 1,
    duration: 900,
    restBetweenSets: 0,
    description: "Relaxing meditation",
    videoURL: nil,
    tips: ["Focus on your breathing", "Relax all your muscles"],
    isCompleted: false
    )
    ]
        default:
            return []
        }
    }
}

// MARK: - Supporting Views
struct CategoryPill: View {
    let category: WorkoutType?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(category?.rawValue ?? "All")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct StatCards: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}


// MARK: - Стили кнопок
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue.gradient)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView()
    }
}
