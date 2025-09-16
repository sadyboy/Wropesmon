import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject private var quizDataService = QuizDataService.shared
    @State private var isDataLoaded = false
    
    init() {}
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.showSplashScreen {
                    SplashScreen()
                }
                else {
                    MainTabView()
                }
            }
            .animation(.spring(), value: viewModel.showSplashScreen)
            .onAppear {
                loadQuizData()
            }
        }
    }
    private func loadQuizData() {
        quizDataService.loadAllQuizzes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isDataLoaded = true
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var viewModel: AppViewModel
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.backgroundColor = .black.withAlphaComponent(0.82)
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
            LinearGradient(colors: [.clas1, .colorS], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(.brilliant)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text("Forge Diamond")
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
