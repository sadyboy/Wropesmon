import SwiftUI

@main
struct SportIQApp: App {
    @StateObject private var appViewModel = AppViewModel()
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
            
        }
    }
}
