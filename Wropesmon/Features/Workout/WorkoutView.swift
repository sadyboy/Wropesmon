import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var showTipSheet = false
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            if viewModel.isWorkoutActive {
                activeWorkoutView
            } else {
                workoutCompletedView
            }
            
            if viewModel.showTip {
                tipOverlay
            }
        }
        .navigationTitle("Training")
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.clas1, Color.black.opacity(0.5)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var activeWorkoutView: some View {
        VStack(spacing: 20) {
            workoutProgress
            currentExerciseCard
            controlButtons
        }
        .padding()
    }
    
    private var workoutProgress: some View {
        VStack(spacing: 8) {
            ProgressBar(progress: viewModel.progress)
                .frame(height: 8)
            
            if let timeRemaining = viewModel.exerciseTimeRemaining {
                Text(timeString(from: timeRemaining))
                   .font(.anton(.h2))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var currentExerciseCard: some View {
        VStack {
            if let exercise = viewModel.currentExercise {
                ExerciseCard(exercise: exercise)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.currentExerciseIndex)
    }
    
    private var controlButtons: some View {
        HStack(spacing: 20) {
            Button(action: { showTipSheet = true }) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.anton(.h1))
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $showTipSheet) {
                TipsSheet(exercise: viewModel.currentExercise)
            }
            
            Button("Next exercise") {
                withAnimation {
                    viewModel.nextExercise()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var tipOverlay: some View {
        VStack {
            if let tip = viewModel.currentTip {
                Text(tip)
                    .font(.callout)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.showTip)
        .padding(.top)
    }
    
    private var workoutCompletedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
                .pulseAnimation()
            
            Text("Workout complete!")
            .font(.anton(.h1))
            .fontWeight(.bold)

            Text("Workout time: \(timeString(from: viewModel.totalWorkoutTime))")
               .font(.anton(.h2))
            
            Button("Finish") {
                // Действие для возврата к списку тренировок
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    @State private var isShowingVideo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.name)
               .font(.anton(.h2))
                .fontWeight(.bold)
            
            Text(exercise.description)
                .font(.body)
            
            if let sets = exercise.sets, let reps = exercise.repetitions {
                HStack {
                    Label("\(sets) of approach", systemImage: "repeat.circle")
                    Spacer()
                    Label("\(reps) of repetitions", systemImage: "figure.walk")
                }
                .font(.callout)
            }
            
            if let videoURL = exercise.videoURL {
                Button("Watch video") {
                    isShowingVideo = true
                }
                .sheet(isPresented: $isShowingVideo) {
                    VideoPlayer(url: videoURL)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct TipsSheet: View {
    let exercise: Exercise?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if let exercise = exercise {
                    ForEach(exercise.tips, id: \.self) { tip in
                        TipRow(tip: tip)
                    }
                }
            }
            .navigationTitle("Trainer's Tips")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct TipRow: View {
    let tip: String
    
    var body: some View {
        HStack {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.yellow)
            Text(tip)
                .font(.body)
        }
        .padding(.vertical, 8)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * progress)
                    .animation(.spring(), value: progress)
            }
        }
        .cornerRadius(4)
    }
}

struct VideoPlayer: View {
    let url: URL
    
    var body: some View {
        Text("Video exercises")
        // Здесь будет реальный видеоплеер
    }
}
