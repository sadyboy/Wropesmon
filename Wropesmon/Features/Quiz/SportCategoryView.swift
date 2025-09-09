import SwiftUI

struct SportCategoryView: View {
    @State private var selectedCategory: SportCategory?
    @State private var showQuiz = false
    
    var body: some View {
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
        .navigationTitle("Select category")
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
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(15)
                .padding()
        }
        .transition(.move(edge: .bottom))
    }
}

struct CategoryCards: View {
    let category: SportCategory
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 40))
            
            Text(category.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(category.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: isSelected ? .blue.opacity(0.3) : .gray.opacity(0.2),
                       radius: isSelected ? 10 : 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(), value: isSelected)
    }
}
