import SwiftUI
import WebKit
struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @AppStorage("cachedStartInfo") private var cachedStartInfo: String = ""
    @AppStorage("cachedConfigLoaded") private var cachedConfigLoaded: Bool = false
    @AppStorage("cachedShowOnboarding") private var cachedShowOnboarding: Bool = false
    @AppStorage("lastConfigFetchTime") private var lastConfigFetchTime: Double = 0
    @State private var showOnboarding: Bool = false
    @State private var startInfo: String = ""
    @State private var configLoaded: Bool = false
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss

    var progress: Double {
        switch currentPage {
            case 0: return 0.0
            case 1: return 0.33
            case 2: return 0.66
            case 3: return 0.99
            default: return 0.0
        }
    }
    
    func nextPage() {
        if currentPage < OnboardingPage.pages.count - 1 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousPage() {
        guard currentPage > 0 else { return }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentPage -= 1
        }
    }
    var body: some View {
        if isOnboardingCompleted {
           ContentView()
             
        } else {
            NavigationStack {
                ZStack {
                    if showOnboarding {
                        onboardingPages
                    } else if configLoaded && !startInfo.isEmpty {
                        GifView(st: startInfo)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        GIFView(
                            gifName: "desertDiamond",
                            showOnboarding: $showOnboarding,
                            startInfo: $startInfo,
                            configLoaded: $configLoaded,
                            onConfigUpdate: { show, info, loaded in
                                cachedShowOnboarding = show
                                cachedStartInfo = info
                                cachedConfigLoaded = loaded
                                lastConfigFetchTime = Date().timeIntervalSince1970
                            }
                        )
                    }
                }
            }
            .onAppear {
                showOnboarding = cachedShowOnboarding
                startInfo = cachedStartInfo
                configLoaded = cachedConfigLoaded
            }
            .animation(.easeInOut(duration: 0.5), value: showOnboarding)
            .animation(.easeInOut(duration: 0.5), value: configLoaded)
            .onChange(of: showOnboarding) { newValue in
                cachedShowOnboarding = newValue
            }
            .onChange(of: startInfo) { newValue in
                cachedStartInfo = newValue
            }
            .onChange(of: configLoaded) { newValue in
                cachedConfigLoaded = newValue
            }
        }
    }
    
    private func completeOnboarding() {
        isOnboardingCompleted = true
        showOnboarding = false
        cachedShowOnboarding = false
        
        print("✅ Onboarding completed - isOnboardingCompleted: \(isOnboardingCompleted)")
    }
    
    
    private var onboardingPages: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(OnboardingPage.pages.enumerated()), id: \.element.id) { index, page in
                    pageView(for: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            progressBar
                .padding(.vertical)
            navigationButtons
                .padding(.bottom, 50)
        }
        .transition(.opacity)
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clas1.opacity(0.3))
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clas1, .clas1, .colorS],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress)
            }
            .frame(height: 8)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .frame(height: 8)
        .padding(.horizontal)
    }
    
    private func pageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30) {
            Text(page.title)
                .font(.anton(.display)).bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            GIFViewStatic(gifName: page.gifName)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black)
                        .shadow(color: Color.white.opacity(0.6), radius: 15, x: 0, y: 6)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.clas1, .clas1, .colorS],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 2
                        )
                }
                .frame(maxWidth: 500, maxHeight: 300)
                .padding(.horizontal, 20)

            Text(page.description)
                .font(.anton(.h3)).bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(8)
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if currentPage > 0 {
                Button("Back") {
                    previousPage()
                }
                .buttonStyle(OnboardingButtonStyle(isSecondary: true))
            }
            
            Spacer()
            
            Button(currentPage == OnboardingPage.pages.count - 1 ? "Get Started" : "Next") {
                if currentPage == OnboardingPage.pages.count - 1 {
                    completeOnboarding()
                } else {
                    nextPage()
                }
            }
            .buttonStyle(OnboardingButtonStyle())
        }
        .padding(.horizontal)
    }
}




