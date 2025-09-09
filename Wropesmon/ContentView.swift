import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject private var quizDataService = QuizDataService.shared
       @State private var isDataLoaded = false
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
        // Небольшая задержка для демонстрации загрузки
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isDataLoaded = true
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label(Tab.home.title, systemImage: Tab.home.icon)
            }
            .tag(Tab.home)
            
     
            NavigationView {
                SportCategoryView()
            }
            .tabItem {
                Label(Tab.quiz.title, systemImage: Tab.quiz.icon)
            }
            .tag(Tab.quiz)
            
            NavigationView {
                WorkoutListView()
            }
            .tabItem {
                Label(Tab.predictions.title, systemImage: Tab.predictions.icon)
            }
            .tag(Tab.predictions)
            
            NavigationView {
                ProfileView()
            }
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
                    .font(.largeTitle)
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
