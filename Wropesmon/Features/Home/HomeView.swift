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
            ZStack {
                
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        activityRingSection
                        quickStartSection
                        workoutAnalyticsSection
                        
                    }
                    .padding()
                }
                .background(
                    LinearGradient(colors: [.clas1, .colorS], startPoint: .top, endPoint: .bottom)
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingProfile = true
                        } label: {
                            Image(systemName: "person.circle.fill")
                               .font(.anton(.h2))
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
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let user = viewModel.currentUser {
                HStack(spacing: 14) {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(String(user.username.prefix(1)))
                                .font(.anton(.h2))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                        .shadow(color: .blue.opacity(0.4), radius: 6, x: 0, y: 3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(getGreeting())
                            .font(.anton(.subheadline))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("\(user.username)! 💎")
                            .font(.anton(.h2))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(Date.now, format: .dateTime.weekday(.wide))
                            .font(.anton(.caption2))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Today")
                            .font(.anton(.caption))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.25))
                            )
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Level: \(user.fitnessLevel.rawValue)")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.5))
                    
                    ProgressView(value: Double(user.fitnessLevel.rawValue) ?? 0,
                                 total: 10)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 5)
                        .cornerRadius(3)
                }
                .padding(.top, 6)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
        )
    }
    

    
    // MARK: - Activity Rings Section
    private var activityRingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity today")
                .font(.anton(.h1))
                .foregroundColor(.white)
            
            HStack(spacing: 24) {
                ActivityRingView(
                    value: activeEnergy,
                    goal: 500,
                    gradient: [.orange, .red],
                    label: "Calories",
                    unit: "kcal"
                )
                
                ActivityRingView(
                    value: Double(exerciseMinutes),
                    goal: 60,
                    gradient: [.green, .mint],
                    label: "Exercises",
                    unit: "min"
                )
                
                ActivityRingView(
                    value: Double(standHours),
                    goal: 12,
                    gradient: [.blue, .purple],
                    label: "Standing",
                    unit: "hrs"
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
        )
    }

    struct ActivityRingView: View {
        var value: Double
        var goal: Double
        var gradient: [Color]
        var label: String
        var unit: String
        
        var progress: Double { min(value / goal, 1.0) }
        
        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(colors: gradient, center: .center),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 1.0), value: progress)
                    
                    VStack {
                        Text("\(Int(value))")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text(unit)
                            .font(.anton(.caption2))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 72, height: 72)
                
                Text(label)
                    .font(.anton(.caption))
                    .foregroundColor(.secondary)
            }
        }
    }

    
    // MARK: - Quick Start Section
     private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick start")
                .font(.anton(.h1))
                .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .leading, endPoint: .trailing))
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                QuickStartCard(title: "Running", icon: "figure.run", colors: [.orange, .red]) {
                    startQuickWorkout(type: .cardio)
                }
                QuickStartCard(title: "Power", icon: "dumbbell.fill", colors: [.blue, .cyan]) {
                    startQuickWorkout(type: .strength)
                }
                QuickStartCard(title: "Yoga", icon: "figure.yoga", colors: [.green, .mint]) {
                    startQuickWorkout(type: .flexibility)
                }
                QuickStartCard(title: "Rest", icon: "bed.double.fill", colors: [.purple, .pink]) {
                    startQuickWorkout(type: .recovery)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
        )
    }

    struct QuickStartCard: View {
        var title: String
        var icon: String
        var colors: [Color]
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(
                            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(Circle())
                    
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, minHeight: 120)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.4)]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                .shadow(color: colors.first!.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.automatic) 
        }
    }


    // MARK: - Workout Analytics Section (заменяет Categories)
     private var workoutAnalyticsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Training statistics")
                    .font(.anton(.h1))
                    .foregroundStyle(.linearGradient(colors: [.blue, .indigo], startPoint: .leading, endPoint: .trailing))
                
                Spacer()
                
                Button("More details") {
                    showingAnalytics.toggle()
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white.opacity(0.9))
            }
            
            weeklyActivityChart
            
            HStack(spacing: 16) {
                AnalyticsCard(value: "\(viewModel.currentUser?.statistics.totalWorkouts ?? 0)",
                              title: "Workout",
                              icon: "figure.run",
                              colors: [.blue, .cyan])
                
                AnalyticsCard(value: "\(viewModel.currentUser?.statistics.workoutMinutes ?? 0)",
                              title: "Minutes",
                              icon: "clock.fill",
                              colors: [.green, .mint])
                
                AnalyticsCard(value: "\(viewModel.currentUser?.statistics.streakDays ?? 0)",
                              title: "Streak",
                              icon: "flame.fill",
                              colors: [.orange, .red])
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
        )
    }

    struct AnalyticsCard: View {
        var value: String
        var title: String
        var icon: String
        var colors: [Color]
        
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Circle())
                
                Text(value)
                    .font(.anton(.h2).bold())
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.anton(.caption))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.4)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
            )
            .shadow(color: colors.first!.opacity(0.25), radius: 8, x: 0, y: 4)
        }
    }


    // MARK: - Weekly Activity Chart
    private var weeklyActivityChart: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity for the week")
               .font(.anton(.subheadline))
                .foregroundColor(.white)
            
            HStack(alignment: .bottom, spacing: 8) {
            
                ForEach(Array(WeekDay.allCases.enumerated()), id: \.element) { index, day in
                    VStack(spacing: 6) {
                        Text("\(day.activityLevel)")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(day.activityLevel > 0 ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: CGFloat(day.activityLevel) * 15)
                        
                        Text(day.shortName)
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120)
        }
    }
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
                    .foregroundColor(.white.opacity(0.7))
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
                   .font(.anton(.h1))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("All quizzes") {
                }
               .font(.anton(.subheadline))
                .foregroundColor(.blue)
            }
            
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
                        .foregroundColor(.white)
                    Text(label)
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
    }

    // MARK: - Detailed Analytics View
    struct DetailedAnalyticsView: View {
        @EnvironmentObject var viewModel: AppViewModel
        @Environment(\.dismiss) var dimiss
        var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.9), Color.blue.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: 20) {
                            overallStatsSection
                            detailedWorkoutStatsSection
                            detailedQuizStatsSection
                            achievementsSection
                        }
                        .padding()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Back") {
                                dimiss.callAsFunction()
                            }
                            .foregroundColor(.white)
                           
                        }
                    }
                    .toolbar {
                        ToolbarItem {
                            Text("Detailed analytics")
                                .foregroundColor(.white)
                                .font(.anton(.h1))
                        }
                    }
                }
            }
        }
        
        // MARK: - Overall Stats Section
        private var overallStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("General statistics")
                    .font(.anton(.h2))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    StatCard(icon: "figure.run", value: "\(viewModel.currentUser?.statistics.totalWorkouts ?? 0)", title: "Workout", color: .blue)
                    StatCard(icon: "questionmark.circle", value: "\(viewModel.currentUser?.statistics.totalQuizzes ?? 0)", title: "Quizzes", color: .green)
                    StatCard(icon: "clock", value: "\(viewModel.currentUser?.statistics.workoutMinutes ?? 0)", title: "Minutes", color: .orange)
                    StatCard(icon: "flame", value: "\(viewModel.currentUser?.statistics.streakDays ?? 0)", title: "Days in a row", color: .red)
                }
            }
            .padding()
            .background(.black.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        
        // MARK: - Detailed Workout Stats Section
        private var detailedWorkoutStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Training statistics")
                   .font(.anton(.h2))
                   .foregroundColor(.white)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Distribution by types")
                       .font(.anton(.h1))
                       .foregroundColor(.white)
                    
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            VStack(spacing: 6) {
                                Text("\(typeWorkoutCount(type))")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colorForWorkoutType(type))
                                    .frame(height: CGFloat(typeWorkoutCount(type)) * 8)
                                
                                Text(type.rawValue.prefix(3))
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 100)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
                
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
            .background(Color.black.opacity(0.5))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Detailed Quiz Stats Section
        private var detailedQuizStatsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Quiz statistics")
                   .font(.anton(.h2))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
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
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Results by category")
                       .font(.anton(.h1))
                       .foregroundColor(.white)
                    
                    ForEach(SportCategory.allCases.prefix(3), id: \.self) { category in
                        HStack {
                            Text(category.icon)
                            Text(category.rawValue)
                               .font(.anton(.subheadline))
                               .foregroundColor(.white)
                            Spacer()
                            Text("\(categoryQuizScore(category)) points")
                               .font(.anton(.subheadline))
                               .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Achievements Section
        private var achievementsSection: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Achievements")
                   .font(.anton(.h2))
                   .foregroundColor(.white)
                    .fontWeight(.bold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                    ForEach(viewModel.achievements.prefix(6), id: \.id) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                
                if viewModel.achievements.count > 6 {
                    Button("All achievements") {
                    }
                   .font(.anton(.subheadline))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(.black.opacity(0.5))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        
        // MARK: - Helper Methods
        private var totalQuizAnswers: Int {
            (viewModel.currentUser?.statistics.totalQuizzes ?? 0) * 10
        }
        
        private var quizAccuracy: Int {
            guard totalQuizAnswers > 0 else { return 0 }
            return Int(Double(viewModel.currentUser?.statistics.correctAnswers ?? 0) / Double(totalQuizAnswers) * 100)
        }
        
        private var estimatedCaloriesBurned: Int {
            (viewModel.currentUser?.statistics.workoutMinutes ?? 0) * 10
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
                    .stroke(Color.white.opacity(0.1), lineWidth: 12)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        AngularGradient(colors: [.green, .blue], center: .center),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                
                VStack {
                    Text("75%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("Accuracy")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
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
                   .font(.anton(.h3))
                    .foregroundColor(color)
                
                Text(value)
                   .font(.anton(.h2))
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.anton(.caption))
                    .foregroundColor(.white.opacity(0.7))
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
                    .font(.system(size: 28))
                    .foregroundColor(achievement.isUnlocked ? .yellow : .gray)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle().fill(achievement.isUnlocked ? Color.blue.opacity(0.4) : Color.black.opacity(0.3))
                    )
                    .shadow(color: achievement.isUnlocked ? .yellow.opacity(0.4) : .clear,
                            radius: 6, x: 0, y: 3)
                
                Text(achievement.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? .white : .white.opacity(0.7))
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
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(
                            LinearGradient(colors: [color, color.opacity(0.7)],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(Circle())
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Text(value)
                        .font(.anton(.h1))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(title)
                        .font(.anton(.caption))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
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
                   .font(.anton(.h2))
                    .foregroundColor(.white)
                
                Text(title)
                   .font(.anton(.subheadline))
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
                   .font(.anton(.h3))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(colorForWorkoutType(type).opacity(0.8)))
                
                Text(type.rawValue)
                   .font(.anton(.subheadline))
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

