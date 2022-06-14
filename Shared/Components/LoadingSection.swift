//
//  LoadingSection.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

struct LoadingSection: View {
    
    @State var rotation: CGFloat = 0
    
    var repeatingAnimation: Animation {
            Animation
                .linear(duration: 1)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        Image("Component/Loading Progress")
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(repeatingAnimation) {
                    rotation = 360
                }
            }
    }
}

struct LoadingSection_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSection()
    }
}
