import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ZStack {
            if viewModel.showSplashScreen {
                SplashScreen()
            } else {
                MainTabView()
            }
        }
        .animation(.spring(), value: viewModel.showSplashScreen)
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
                WorkoutView()
            }
            .tabItem {
                Label("Тренировки", systemImage: "figure.run")
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

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                welcomeSection
                featuredQuizzes
                workoutSection
            }
            .padding()
        }
        .navigationTitle("SportIQ")
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Привет, спортсмен! 👋")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Готов к новым достижениям?")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var featuredQuizzes: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Популярные квизы")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(SportCategory.allCases.prefix(5), id: \.self) { category in
                        NavigationLink(destination: QuizView(category: category)) {
                            FeaturedQuizCard(category: category)
                        }
                    }
                }
            }
        }
    }
    
    private var workoutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Тренировки")
                .font(.title2)
                .fontWeight(.bold)
            
            NavigationLink(destination: WorkoutView()) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Начать тренировку")
                            .font(.headline)
                        Text("Персональный план")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title2)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            }
        }
    }
}

struct FeaturedQuizCard: View {
    let category: SportCategory
    
    var body: some View {
        VStack(spacing: 10) {
            Text(category.icon)
                .font(.system(size: 40))
            
            Text(category.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: 120)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                statisticsSection
                achievementsSection
            }
            .padding()
        }
        .navigationTitle("Профиль")
    }
    
    private var profileHeader: some View {
        VStack(spacing: 15) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Спортсмен")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Уровень: Продвинутый")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Статистика")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                StatCard(title: "Квизы", value: "15", icon: "checkmark.circle.fill")
                StatCard(title: "Тренировки", value: "8", icon: "figure.run")
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Достижения")
                .font(.title2)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    AchievementCard(title: "Первый квиз", icon: "star.fill", isUnlocked: true)
                    AchievementCard(title: "Спортсмен", icon: "figure.run", isUnlocked: true)
                    AchievementCard(title: "Эксперт", icon: "brain", isUnlocked: false)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

struct AchievementCard: View {
    let title: String
    let icon: String
    let isUnlocked: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(isUnlocked ? .yellow : .gray)
            
            Text(title)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100, height: 100)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
        .opacity(isUnlocked ? 1 : 0.5)
    }
}