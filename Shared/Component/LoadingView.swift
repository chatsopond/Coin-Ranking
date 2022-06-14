//
//  LoadingView.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

enum LoadingViewStyle {
    case plain, button
}

struct LoadingView: View {
    
    let style: LoadingViewStyle
    @State var rotation: CGFloat = 0
    
    var repeatingAnimation: Animation {
            Animation
                .linear(duration: 1)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        content
            .onAppear {
                withAnimation(repeatingAnimation) {
                    rotation = 360
                }
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch style {
        case .plain:
            normal
        case .button:
            button
        }
    }
    
    var normal: some View {
        Image("Component/Loading Progress")
            .rotationEffect(.degrees(rotation))
    }
    
    var button: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 48, height: 48)
            .overlay(
                Image("Component/Loading Progress 2")
                    .rotationEffect(.degrees(rotation))
            )
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct LoadingSection_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(style: .plain)
            .previewLayout(.sizeThatFits)
        LoadingView(style: .button)
            .previewLayout(.sizeThatFits)
    }
}
