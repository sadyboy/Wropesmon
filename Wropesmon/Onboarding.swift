//
//  Onboarding.swift
//  Wropesmon
//
//  Created by Serhii Anp on 10.09.2025.
//

import Foundation
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let gifName: String

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome",
            description: "Find balance between body and mind — train, meditate, and grow every day.",
            gifName: "gifOne"
        ),
        OnboardingPage(
            title: "Choose Your Workouts",
            description: "Build your own routine: select exercises and focus on the muscle groups you want to improve.",
            gifName: "gifTwo"
        ),
        OnboardingPage(
            title: "Meditate & Recover",
            description: "It’s not just about strength — practice meditation to relax and refocus.",
            gifName: "gifThree"
        )
    ]
}
