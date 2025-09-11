import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted: Bool = false
    @AppStorage("startInfo") private var startInfo: String = ""
    @State private var currentPage = 0
    var progress: Double {
        switch currentPage {
            case 0: return 0.0
            case 1: return 0.33
            case 2: return 0.66
            case 3: return 0.99
            default: return 0.0
        }
    }
    @AppStorage("IDStart") private var startID: String = ""
    
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
    
    private func completeOnboarding() {
        isOnboardingCompleted = true
    }
    

    var body: some View {
        ZStack {
//            Color(.mainCrl)
//                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                TabView(selection: .constant(currentPage)) {
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
            .opacity(startInfo.isEmpty ? 1 : 0)
            GIFView(gifName: "gifOne")
                .opacity(startInfo.isEmpty ? 0 : 1)
            
                .ignoresSafeArea(edges: .bottom)
        }
        .id(startID)
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clas1)
                
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
            .frame(height: 10)
            .clipShape(RoundedRectangle(cornerRadius: 5))
        }
        .frame(height: 10)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .padding(.horizontal)
    }
    
    private func pageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30) {
            Text(page.title)
                .font(.anton(.display)).bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            GIFView(gifName: page.gifName)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .shadow(color: Color.red.opacity(0.9), radius: 10, x: 0, y: 4)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(LinearGradient(
                            colors: [.clas1, .clas1, .colorS],
                            startPoint: .leading,
                            endPoint: .trailing
                        ).opacity(0.8), lineWidth: 3)
                }
                .frame(maxWidth: 500 ,maxHeight: 300)
                .padding(.horizontal, 10)


            Text(page.description)
               .font(.anton(.h3)).bold()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            Button(currentPage == OnboardingPage.pages.count - 1 ? "Start" : "Next") {
                if currentPage == OnboardingPage.pages.count - 1 {
                    isOnboardingCompleted = true
                } else {
                    nextPage()
                }
            }
            .buttonStyle(OnboardingButtonStyle())
        }
        .padding(.horizontal)
    }
}

struct OnboardingButtonStyle: ButtonStyle {
    let isSecondary: Bool
    
    init(isSecondary: Bool = false) {
        self.isSecondary = isSecondary
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
               .font(.custom("ChangaOne-Regular", size: 18))
               .foregroundColor(.white)
               .frame(width: 200, height: 43)
               .background(
                   ZStack {
                       LinearGradient(
                        colors: [.clas1, .clas1, .colorS],
                           startPoint: .leading,
                           endPoint: .trailing
                       )
                       .clipShape(RoundedRectangle(cornerRadius: 10))

                       RoundedRectangle(cornerRadius: 10)
                           .stroke(Color.white.opacity(0.8), lineWidth: configuration.isPressed ? 2 : 1)
                           .blur(radius: configuration.isPressed ? 4 : 2)
                           .opacity(configuration.isPressed ? 1 : 0.7)
                   }
               )
               .clipShape(RoundedRectangle(cornerRadius: 10))
               .shadow(color: .red.opacity(0.8), radius: configuration.isPressed ? 8 : 4, x: 0, y: 4)
               .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

#Preview {
    OnboardingView()
}
