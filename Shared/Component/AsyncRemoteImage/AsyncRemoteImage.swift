//
//  AsyncRemoteImage.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import CachedAsyncImage

/// A view that displays an image from remote URL
struct AsyncRemoteImage: View {
    var url: URL?
    
    var body: some View {
        if let url = url,
           url.pathExtension.contains("svg") {
            SVGAsyncImage(remoteURL: url)
        } else {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
        }
    }
}

struct AsyncRemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        AsyncRemoteImage(url: URL(string: "https://cdn.coinranking.com/UJ-dQdgYY/8085.png"))
        AsyncRemoteImage(url: URL(string: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg"))
    }
}
