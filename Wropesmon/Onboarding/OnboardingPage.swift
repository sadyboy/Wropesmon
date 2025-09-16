import Foundation
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let gifName: String

    static let pages: [OnboardingPage] = [
            OnboardingPage(
                title: "Welcome to Forge Diamond",
                description: "Your path to balance — train, play, and track your growth every day.",
                gifName: "desertDiamond"
            ),
            OnboardingPage(
                title: "Choose Your Workouts",
                description: "Explore themed programs and build routines that fit your goals.",
                gifName: "gif1"
            ),
            OnboardingPage(
                title: "Play Quizzes",
                description: "Challenge yourself with fun fitness and health quizzes to stay motivated.",
                gifName: "gif2"
            ),
            OnboardingPage(
                title: "Track Your Progress",
                description: "Monitor your statistics, analyze results, and set new milestones.",
                gifName: "gif3"
            )
        ]
    }
