import SwiftUI

enum WeekDay: String, CaseIterable, Identifiable, Hashable {
    var id: String { rawValue }
    case mon, tue, wed, thu, fri, sat, sun
    
    var shortName: String {
        switch self {
            case .mon: return "Mon"
            case .tue: return "Tue"
            case .wed: return "Wed"
            case .thu: return "Thu"
            case .fri: return "Fri"
            case .sat: return "Sat"
            case .sun: return "Sun"
        }
    }
    
    var activityLevel: Int {
        switch self {
        case .mon: return Int.random(in: 2...5)
        case .tue: return Int.random(in: 3...6)
        case .wed: return Int.random(in: 1...4)
        case .thu: return Int.random(in: 4...7)
        case .fri: return Int.random(in: 2...5)
        case .sat: return Int.random(in: 0...3)
        case .sun: return Int.random(in: 1...4)
        }
    }
}


struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedWorkout: WorkoutSession?
    @State private var showingWorkoutDetail = false
    @State private var showingProfile = false
    @State private var activeEnergy: Double = 420
    @State private var exerciseMinutes: Int = 35
    @State private var standHours: Int = 10
    @State private var showingAnalytics = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    activityRingSection
                    
                    quickStartSection
                    
                    workoutAnalyticsSection
 
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("SportIQ")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(item: $selectedWorkout) { workout in
                WorkoutDetailView(workout: workout)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .sheet(isPresented: $showingAnalytics) {
                        DetailedAnalyticsView()
                    }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let user = viewModel.currentUser {
                Text(getGreeting())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(user.username)! 👋")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("Level: \(user.fitnessLevel.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.blue.opacity(0.1)))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Activity Rings Section
    private var activityRingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity today")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                // Калории
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.orange.opacity(0.2), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.orange, .red]),
                                    center: .center,
                                    startAngle: .zero,
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(Int(activeEnergy))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            Text("kcal")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 70, height: 70)
                    
                    Text("Calories")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.green.opacity(0.2), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.green, .mint]),
                                    center: .center,
                                    startAngle: .zero,
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(exerciseMinutes)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            Text("min")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 70, height: 70)
                    
                    Text("Exercises")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.2), lineWidth: 8)
                        
                        Circle()
                            .trim(from: 0, to: 0.9)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    center: .center,
                                    startAngle: .zero,
                                    endAngle: .degrees(360)
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(standHours)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.primary)
                            Text("hour")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 70, height: 70)
                    
                    Text("Standing")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    // MARK: - Quick Start Section
    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick start")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                QuickActionButton(
                    title: "Running",
                    icon: "figure.run",
                    color: .orange,
                    action: { startQuickWorkout(type: .cardio) }
                )
                
                QuickActionButton(
                    title: "Power",
                    icon: "dumbbell.fill",
                    color: .blue,
                    action: { startQuickWorkout(type: .strength) }
                )
                
                QuickActionButton(
                    title: "Yoga",
                    icon: "figure.yoga",
                    color: .green,
                    action: { startQuickWorkout(type: .flexibility) }
                )
                
                QuickActionButton(
                    title: "Rest",
                    icon: "bed.double.fill",
                    color: .purple,
                    action: { startQuickWorkout(type: .recovery) }
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    // MARK: - Workout Analytics Section (заменяет Categories)
    private var workoutAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Training statistics")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("More details") {
                    showingAnalytics.toggle()
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            weeklyActivityChart
            
            HStack(spacing: 15) {
                AnalyticsMetricCard(
                    value: "\(viewModel.currentUser?.statistics.totalWorkouts ?? 0)",
                    title: "Workout",
                    icon: "figure.run",
                    color: .blue
                )
                
                AnalyticsMetricCard(
                    value: "\(viewModel.currentUser?.statistics.workoutMinutes ?? 0)",
                    title: "Minutes",
                    icon: "clock",
                    color: .green
                )
                
                AnalyticsMetricCard(
                    value: "\(viewModel.currentUser?.statistics.streakDays ?? 0)",
                    title: "Days in a row",
                    icon: "flame",
                    color: .orange
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        
    }

    // MARK: - Weekly Activity Chart
    private var weeklyActivityChart: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity for the week")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 8) {
            
                ForEach(Array(WeekDay.allCases.enumerated()), id: \.element) { index, day in
                    VStack(spacing: 6) {
                        Text("\(day.activityLevel)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(day.activityLevel > 0 ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: CGFloat(day.activityLevel) * 15)
                        
                        Text(day.shortName)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120)
        }
    }

    // MARK: - Supporting Structures
 

    // MARK: - Analytics Metric Card
    struct AnalyticsMetricCard: View {
        let value: String
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(color))
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }

    // MARK: - Quiz Statistics Section
    private var quizStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Quiz statistics")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("All quizzes") {
                    // Переход к списку квизов
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            // Прогресс правильных ответов
            HStack(spacing: 20) {
                QuizProgressRing(
                    correctAnswers: viewModel.currentUser?.statistics.correctAnswers ?? 0,
                    totalAnswers: (viewModel.currentUser?.statistics.totalQuizzes ?? 0) * 10,
                    title: "Accuracy"
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    QuizStatRow(
                        icon: "checkmark.circle",
                        value: "\(viewModel.currentUser?.statistics.totalQuizzes ?? 0)",
                        label: "Quizzes completed"
                    )
                    
                    QuizStatRow(
                        icon: "star",
                        value: "\(viewModel.currentUser?.statistics.correctAnswers ?? 0)",
                        label: "Correct answers"
                    )
                    
                    QuizStatRow(
                        icon: "trophy",
                        value: "\((viewModel.currentUser?.statistics.correctAnswers ?? 0) * 10)",
                        label: "Total points"
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }

    // MARK: - Quiz Progress Ring
    struct QuizProgressRing: View {
        let correctAnswers: Int
        let totalAnswers: Int
        let title: String
        
        private var progress: Double {
            totalAnswers > 0 ? Double(correctAnswers) / Double(totalAnswers) : 0
        }
        
        private var percentage: Int {
            Int(progress * 100)
        }
        
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.green, .mint]),
                                center: .center,
                                startAngle: .zero,
                                endAngle: .degrees(360)
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(percentage)%")
                            .font(.system(size: 16, weight: .bold))
                        Text(title)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Quiz Stat Row
    struct QuizStatRow: View {
        let icon: String
        let value: String
        let label: String
        
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                VStack(alignment: .leading) {
                    Text(value)
                        .font(.system(size: 14, weight: .semibold))
                    Text(label)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Detailed Analytics View
    struct DetailedAnalyticsView: View {
        @EnvironmentObject var viewModel: AppViewModel
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        overallStatsSection
                        detailedWorkoutStatsSection
                        detailedQuizStatsSection
                        achievementsSection
                    }
                    .padding()
                }
                .navigationTitle("Detailed analytics")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Ready") {
                            // Закрыть экран
                        }
                    }
                }
            }
        }
        
        // MARK: - Overall Stats Section
        private var overallStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("General statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    StatCard(
                        icon: "figure.run",
                        value: "\(viewModel.currentUser?.statistics.totalWorkouts ?? 0)",
                        title: "Workout",
                        color: .blue
                    )
                    
                    StatCard(
                        icon: "questionmark.circle",
                        value: "\(viewModel.currentUser?.statistics.totalQuizzes ?? 0)",
                        title: "Quize",
                        color: .green
                    )
                    
                    StatCard(
                        icon: "clock",
                        value: "\(viewModel.currentUser?.statistics.workoutMinutes ?? 0)",
                        title: "minutes",
                        color: .orange
                    )
                    
                    StatCard(
                        icon: "flame",
                        value: "\(viewModel.currentUser?.statistics.streakDays ?? 0)",
                        title: "Days in a row",
                        color: .red
                    )
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Detailed Workout Stats Section
        private var detailedWorkoutStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Training statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // График активности по типам тренировок
                VStack(alignment: .leading, spacing: 12) {
                    Text("Distribution by types")
                        .font(.headline)
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            VStack(spacing: 6) {
                                Text("\(typeWorkoutCount(type))")
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colorForWorkoutType(type))
                                    .frame(height: CGFloat(typeWorkoutCount(type)) * 8)
                                
                                Text(type.rawValue.prefix(3))
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 100)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Дополнительная статистика
                HStack(spacing: 15) {
                    MetricCard(
                        value: "\((viewModel.currentUser?.statistics.workoutMinutes ?? 0) / 60)",
                        title: "Hours of training",
                        icon: "clock.fill",
                        color: .purple
                    )
                    
                    MetricCard(
                        value: "\(estimatedCaloriesBurned)",
                        title: "Kcal burned",
                        icon: "flame.fill",
                        color: .orange
                    )
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Detailed Quiz Stats Section
        private var detailedQuizStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Quiz statistics")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Прогресс точности
                HStack(spacing: 20) {
                    QuizAccuracyRing()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        QuizStatRow(
                            icon: "checkmark.circle.fill",
                            value: "\(viewModel.currentUser?.statistics.correctAnswers ?? 0)",
                            label: "Correct Answers"
                        )
                        
                        QuizStatRow(
                            icon: "xmark.circle.fill",
                            value: "\(totalQuizAnswers - (viewModel.currentUser?.statistics.correctAnswers ?? 0))",
                            label: "Wrong Answers"
                        )
                        
                        QuizStatRow(
                            icon: "percent",
                            value: "\(quizAccuracy)%",
                            label: "Overall accuracy"
                        )
                    }
                }
                
                // Распределение по категориям
                VStack(alignment: .leading, spacing: 12) {
                    Text("Results by category")
                        .font(.headline)
                    
                    ForEach(SportCategory.allCases.prefix(3), id: \.self) { category in
                        HStack {
                            Text(category.icon)
                            Text(category.rawValue)
                                .font(.subheadline)
                            Spacer()
                            Text("\(categoryQuizScore(category)) points")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Achievements Section
        private var achievementsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Achievements")
                    .font(.title2)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                    ForEach(viewModel.achievements.prefix(6), id: \.id) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                
                if viewModel.achievements.count > 6 {
                    Button("All achievements") {
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Helper Methods
        private var totalQuizAnswers: Int {
            (viewModel.currentUser?.statistics.totalQuizzes ?? 0) * 10 // Предполагаем 10 вопросов на квиз
        }
        
        private var quizAccuracy: Int {
            guard totalQuizAnswers > 0 else { return 0 }
            return Int(Double(viewModel.currentUser?.statistics.correctAnswers ?? 0) / Double(totalQuizAnswers) * 100)
        }
        
        private var estimatedCaloriesBurned: Int {
            (viewModel.currentUser?.statistics.workoutMinutes ?? 0) * 10 // Пример: 10 ккал в минуту
        }
        
        private func typeWorkoutCount(_ type: WorkoutType) -> Int {

            return Int.random(in: 1...10)
        }
        
        private func categoryQuizScore(_ category: SportCategory) -> Int {

            return Int.random(in: 50...200)
        }
        
        private func colorForWorkoutType(_ type: WorkoutType) -> Color {
            switch type {
            case .cardio: return .red
            case .strength: return .blue
            case .flexibility: return .green
            case .sport: return .orange
            case .recovery: return .purple
            }
        }
    }

    // MARK: - Supporting Views
    struct QuizAccuracyRing: View {
        var body: some View {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.75) // 75% точность для демонстрации
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            center: .center,
                            startAngle: .zero,
                            endAngle: .degrees(360)
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack {
                    Text("75%")
                        .font(.system(size: 16, weight: .bold))
                    Text("Accuracy")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    struct MetricCard: View {
        let value: String
        let title: String
        let icon: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }

    struct AchievementBadge: View {
        let achievement: Achievement
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(achievement.isUnlocked ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2)))
                
                Text(achievement.title)
                    .font(.system(size: 10))
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }

    // MARK: - Stat Card
    struct StatCard: View {
        let icon: String
        let value: String
        let title: String
        let color: Color
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }

    
    // MARK: - Helper Methods
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
            case 6..<12: return "Good morning"
            case 12..<18: return "Good afternoon"
            case 18..<24: return "Good evening"
            default: return "Good night"
        }
    }
    
    private func startQuickWorkout(type: WorkoutType) {
        let quickWorkout = sampleWorkoutFor(type: type)
        selectedWorkout = quickWorkout
    }
    
    private func sampleWorkoutFor(type: WorkoutType) -> WorkoutSession {
        WorkoutSession(
            id: UUID().uuidString,
            type: type,
            exercises: generateExercises(for: type),
            duration: 1800,
            date: Date(),
            isCompleted: false,
            caloriesBurned: Int.random(in: 150...400)
        )
    }
    
    private var recommendedWorkouts: [WorkoutSession] {
        [
            sampleWorkoutFor(type: .cardio),
            sampleWorkoutFor(type: .strength),
            sampleWorkoutFor(type: .flexibility)
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
                    duration: 1800,
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
                    description: "Flexibility Exercise Complex",
                    videoURL: nil,
                    tips: ["Breathe Deeply", "Don't Overexert Yourself"],
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
                    description: "Relaxing Meditation",
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
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.gradient)
            )
        }
    }
}

struct CategoryCard: View {
    let type: WorkoutType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconForWorkoutType(type))
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(colorForWorkoutType(type).opacity(0.8)))
                
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
    }
    
    private func colorForWorkoutType(_ type: WorkoutType) -> Color {
        switch type {
        case .cardio: return .orange
        case .strength: return .blue
        case .flexibility: return .green
        case .sport: return .red
        case .recovery: return .purple
        }
    }
    
    private func iconForWorkoutType(_ type: WorkoutType) -> String {
        switch type {
        case .cardio: return "heart.circle.fill"
        case .strength: return "dumbbell.fill"
        case .flexibility: return "figure.yoga"
        case .sport: return "sportscourt.fill"
        case .recovery: return "bed.double.fill"
        }
    }
}
