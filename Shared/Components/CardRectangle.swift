//
//  CardRectangle.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

struct CardRectangle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.cardBackground)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}

struct CardRectangle_Previews: PreviewProvider {
    
    static var paddingSize: CGFloat = 20
    
    static var previews: some View {
        CardRectangle()
            .padding(paddingSize)
            .previewLayout(.fixed(width: 110 + paddingSize, height: 140 + paddingSize))
        
        CardRectangle()
            .padding(paddingSize)
            .previewLayout(.fixed(width: 359 + paddingSize, height: 82 + paddingSize))
        
    }
}
