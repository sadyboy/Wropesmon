import SwiftUI

struct SlideTransition: ViewModifier {
    let isPresented: Bool
    let edge: Edge
    
    func body(content: Content) -> some View {
        content
            .offset(x: isPresented ? 0 : UIScreen.main.bounds.width * (edge == .leading ? -1 : 1))
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isPresented)
    }
}

struct PulseAnimation: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct RotateAnimation: ViewModifier {
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .animation(
                Animation.linear(duration: 2)
                    .repeatForever(autoreverses: false),
                value: rotation
            )
            .onAppear {
                rotation = 360
            }
    }
}

extension View {
    func slideTransition(isPresented: Bool, edge: Edge = .trailing) -> some View {
        modifier(SlideTransition(isPresented: isPresented, edge: edge))
    }
    
    func pulseAnimation() -> some View {
        modifier(PulseAnimation())
    }
    
    func rotateAnimation() -> some View {
        modifier(RotateAnimation())
    }
    
    func cardFlip(isFront: Bool) -> some View {
        rotation3DEffect(
            .degrees(isFront ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isFront)
    }
}
