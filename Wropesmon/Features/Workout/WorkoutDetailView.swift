import SwiftUI

struct WorkoutDetailView: View {
    let workout: WorkoutSession
    @Environment(\.presentationMode) var presentationMode
    @State private var currentExerciseIndex = 0
    @State private var timerProgress: Double = 0
    @State private var timeRemaining: Int = 0
    @State private var isTimerRunning = false
    @State private var isWorkoutCompleted = false
    @State private var showCompletionAlert = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentExercise: WorkoutExercise? {
        guard workout.exercises.indices.contains(currentExerciseIndex) else { return nil }
        return workout.exercises[currentExerciseIndex]
    }
    var totalExercises: Int {
        workout.exercises.count
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(spacing: 25) {
                        progressSection
                        exerciseImageSection
                        exerciseInfoSection
                        timerSection
                        navigationSection
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(workout.type.rawValue)
        .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
        Button("Complete") {
        showCompletionAlert = true
        }
        .foregroundColor(.red)
        }
        }
        .alert("Complete Workout?", isPresented: $showCompletionAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Complete", role: .destructive) {
                completeWorkout()
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning && timeRemaining > 0 {
                timeRemaining -= 1
                timerProgress = Double(timeRemaining) / Double(currentExercise?.duration ?? 60)
            } else if isTimerRunning {
                isTimerRunning = false
                if currentExerciseIndex < totalExercises - 1 {
                    goToNextExercise()
                } else {
                    completeWorkout()
                }
            }
        }
        .onAppear {
            setupExercise()
        }
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Exercise \(currentExerciseIndex + 1) of \(totalExercises)")
               .font(.anton(.subheadline))
                .foregroundColor(.white)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: geometry.size.width * CGFloat(currentExerciseIndex) / CGFloat(totalExercises), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }

    private var exerciseImageSection: some View {
        VStack {
            if let currentExercise = currentExercise {
                Image(exerciseImageName(for: currentExercise.name))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                Text(currentExercise.name)
                    .font(.anton(.h2))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.top, 10)
            }
        }
    }
    
    private var exerciseInfoSection: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                if let duration = currentExercise?.duration {
                InfoCard(
                icon: "clock.fill",
                value: "\(Int(duration)/60) min",
                title: "Duration",
                color: .blue
                )
                }

                InfoCard(
                icon: "repeat",
                value: "\(currentExercise?.sets)x\(currentExercise?.reps)",
                title: "Approaches",
                color: .orange
                )

                InfoCard(
                icon: "restart",
                value: "\(currentExercise?.restBetweenSets)с",
                title: "Rest",
                color: .green
                )
                }
          
            VStack(alignment: .leading, spacing: 10) {
                Text("Description")
               .font(.anton(.h1))
               .foregroundColor(.white)
                Text(currentExercise?.description ?? "")
                .font(.body)
                .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)

                // Adviсe
            if !(currentExercise?.tips.isEmpty ?? false) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tips")
                        .foregroundColor(.white)
                        .font(.anton(.h1))
                    ForEach(currentExercise?.tips ?? [""], id: \.self) { tip in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14))
                            
                            Text(tip)
                               .font(.anton(.subheadline))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(
                    Color.black.opacity(0.5)
                )
                .cornerRadius(15)
            }
        }
    }

    private var timerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: timerProgress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: timerProgress)
                
                VStack {
                    Text(formatTime(timeRemaining))
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text(isTimerRunning ? "Remaining" : "Done")
                    .font(.anton(.caption))
                    .foregroundColor(.white.opacity(0.7))
                    }
                    }

                    // Control buttons
                    HStack(spacing: 20) {
                    if !isTimerRunning {
                    Button(action: startTimer) {
                    HStack {
                    Image(systemName: "play.fill")
                    Text("Start")
                    }
                   .font(.anton(.h1))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(15)
                    }
                    } else {
                    Button(action: pauseTimer) {
                    HStack {
                    Image(systemName: "pause.fill")
                    Text("Pause")
                    }
                       .font(.anton(.h1))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(15)
                    }
                    
                    Button(action: stopTimer) {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("Stop")
                        }
                       .font(.anton(.h1))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(20)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var navigationSection: some View {
        HStack(spacing: 15) {
            Button(action: goToPreviousExercise) {
                HStack {
                Image(systemName: "arrow.left")
                Text("Back")
                }
               .font(.anton(.h1))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(currentExerciseIndex > 0 ? Color.blue : Color.gray)
                .cornerRadius(15)
                }
                .disabled(currentExerciseIndex == 0)

                Button(action: goToNextExercise) {
                HStack {
                Text(currentExerciseIndex == totalExercises - 1 ? "Finish" : "Next")
                Image(systemName: "arrow.right")
                }
               .font(.anton(.h1))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(15)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func exerciseImageName(for exerciseName: String) -> String {
        let imageMap: [String: String] = [
        "Running": "running",
        "Pushups": "pushups",
        "Squats": "squats",
        "Plank": "plank",
        "Pullups": "pullups",
        "Yoga": "yoga",
        "Meditation": "meditation",
        "Burpee": "burpee",
        "Jump rope": "jump_rope",
        "Abs": "abs"
        ]
        return imageMap[exerciseName] ?? "workout_default"
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func setupExercise() {
        timeRemaining = Int(currentExercise?.duration ?? 60)
        timerProgress = 1.0
        isTimerRunning = false
    }
    
    private func startTimer() {
        isTimerRunning = true
    }
    
    private func pauseTimer() {
        isTimerRunning = false
    }
    
    private func stopTimer() {
        isTimerRunning = false
        setupExercise()
    }
    
    private func goToPreviousExercise() {
        if currentExerciseIndex > 0 {
            currentExerciseIndex -= 1
            setupExercise()
        }
    }
    
    private func goToNextExercise() {
        if currentExerciseIndex < totalExercises - 1 {
            currentExerciseIndex += 1
            setupExercise()
        } else {
            completeWorkout()
        }
    }
    
    private func completeWorkout() {
        isWorkoutCompleted = true
        showCompletionAlert = false
        presentationMode.wrappedValue.dismiss()

    }
}

// MARK: - Info Card
struct InfoCard: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(15)
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Preview
struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutDetailView(workout: WorkoutSession(
            id: "1",
            type: .cardio,
            exercises: [
            WorkoutExercise(
            id: "1",
            name: "Running",
            sets: 1,
            reps: 1,
            duration: 300,
            restBetweenSets: 60,
            description: "Moderate pace running to build cardiovascular endurance",
            videoURL: nil,
            tips: [
            "Be aware of your breathing: inhale through your nose, exhale through your mouth",
            "Keep your posture straight, don't slouch",
            "Land on the midfoot"
            ],
            isCompleted: false
            ),
            WorkoutExercise(
            id: "2",
            name: "Plank",
            sets: 3,
            reps: 1,
            duration: 60,
            restBetweenSets: 30,
            description: "Exercise to strengthen the core and abdominal muscles",
            videoURL: nil,
            tips: [
            "Keep your body in a straight line",
            "Tighten your abs and glutes",
            "Don't hold your breath"
            ],
            isCompleted: false
            )
            ],
            duration: 360,
            date: Date(),
            isCompleted: false,
            caloriesBurned: 250
            ))
            }
            }
            }

