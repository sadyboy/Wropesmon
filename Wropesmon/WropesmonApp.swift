import SwiftUI
import SwiftData
@main
struct SportIQApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isOnboardingCompleted {
                    ContentView()
                        .environmentObject(appViewModel)
                } else {
                    OnboardingView(isOnboardingCompleted: $isOnboardingCompleted) 
                            .environmentObject(appViewModel)
                }
            }
            .environment(\.colorScheme, .dark)
            .preferredColorScheme(.dark)
        }
    }
}
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        return .all // iPad support
//    }
//}
