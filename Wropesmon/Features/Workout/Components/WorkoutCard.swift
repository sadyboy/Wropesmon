import SwiftUI

struct WorkoutCard: View {
    let workout: WorkoutSession
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconForWorkoutType(workout.type))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(colorForWorkoutType(workout.type).gradient)
                    )
                
                Spacer()
                
                Text("\(workout.exercises.count) control.")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(colorForWorkoutType(workout.type).opacity(0.2))
                    )
                    .foregroundColor(colorForWorkoutType(workout.type))
            }
            
            Text(workout.type.rawValue)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                    Text("\(Int(workout.duration / 60)) min")
                        .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 13))
                    }

                    if let calories = workout.caloriesBurned {
                    HStack {
                    Image(systemName: "flame")
                    .font(.system(size: 12))
                    Text("\(calories) kcal")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .foregroundColor(.secondary)
            
            Spacer()

            HStack {
                Spacer()
                Text("Start")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(colorForWorkoutType(workout.type).gradient)
            )
        }
        .padding()
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.3))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(colorForWorkoutType(workout.type).opacity(0.3), lineWidth: 1)
        )
        .scaleEffect(isAnimating ? 1.02 : 1)
//        .onAppear {
//            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
//                isAnimating = true
//            }
//        }
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
        case .cardio: return "heart.fill"
        case .strength: return "dumbbell.fill"
        case .flexibility: return "figure.yoga"
        case .sport: return "sportscourt.fill"
        case .recovery: return "bed.double.fill"
        }
    }
}

