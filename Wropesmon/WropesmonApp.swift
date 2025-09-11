import SwiftUI
import SwiftData
@main
struct SportIQApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                ContentView()
                    .environmentObject(appViewModel)
            } else {
                OnboardingView()
            }
        }
    }
}
