import SwiftUI

struct SportCategoryView: View {
    @State private var selectedCategory: SportCategory?
    @State private var showQuiz = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.clas1.opacity(0.8), Color.black.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(SportCategory.allCases, id: \.self) { category in
                        CategoryCards(category: category, isSelected: selectedCategory == category)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    if selectedCategory == category {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Select category")
        .navigationBarTitleDisplayMode(.large)
        .overlay(alignment: .bottom) {
            if selectedCategory != nil {
                startButton
            }
        }
        .sheet(isPresented: $showQuiz) {
            if let category = selectedCategory {
                QuizView(category: category)
            }
        }
    }
    
    private var startButton: some View {
        Button(action: {
            showQuiz = true
        }) {
            Text("Start Quiz")
                .font(.anton(.h3))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(colors: [.blue, .purple],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                )
                .cornerRadius(18)
                .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding()
        }
        .transition(.move(edge: .bottom))
    }
}

// MARK: - Category Cards
struct CategoryCards: View {
    let category: SportCategory
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 44))
            
            Text(category.rawValue)
                .font(.anton(.h2))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(category.description)
                .font(.anton(.caption))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        colors: isSelected ? [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]
                                          : [Color.black.opacity(0.4), Color.black.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: isSelected ? .blue.opacity(0.5) : .black.opacity(0.3),
                        radius: isSelected ? 12 : 6, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? Color.blue.opacity(0.8) : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}
