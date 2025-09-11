import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject private var quizDataService = QuizDataService.shared
    @State private var isDataLoaded = false
    
    init() {
        
    }
    var body: some View {
        ZStack {
            if viewModel.showSplashScreen {
                SplashScreen()
            } else {
                MainTabView()
            }
        }
        .animation(.spring(), value: viewModel.showSplashScreen)
        .onAppear {
            loadQuizData()
        }
    }
    private func loadQuizData() {
        quizDataService.loadAllQuizzes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isDataLoaded = true
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var viewModel: AppViewModel
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground() // <- HERE
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.accentColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(Color.accentColor)]

        UITabBar.appearance().standardAppearance = appearance

    }
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
                HomeView()
            .tabItem {
                Label(Tab.home.title, systemImage: Tab.home.icon)
            }
            .tag(Tab.home)
                SportCategoryView()
            .tabItem {
                Label(Tab.quiz.title, systemImage: Tab.quiz.icon)
            }
            .tag(Tab.quiz)
                WorkoutListView()
            .tabItem {
                Label(Tab.predictions.title, systemImage: Tab.predictions.icon)
            }
            .tag(Tab.predictions)
            
                ProfileView()
            .tabItem {
                Label(Tab.profile.title, systemImage: Tab.profile.icon)
            }
            .tag(Tab.profile)
        }
    }
}

struct SplashScreen: View {
    @State private var scale: CGFloat = 0.7
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("AccentColor")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "figure.run")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("SportIQ")
                    .font(.anton(.display))
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    scale = 1
                    opacity = 1
                }
            }
        }
    }
}
