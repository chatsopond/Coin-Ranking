//
//  SVGAsyncImage.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI
import SVGView

struct SVGAsyncImage: View {
    var remoteURL: URL
    @State var localURL: URL?
    
    var body: some View {
        ZStack {
            if let localURL = localURL {
                SVGView(contentsOf: localURL)
            }
        }
        .onAppear {
            let task = URLSession.shared.dataTask(with: remoteURL) { data, response, error in
                guard let data = data else { return }
                let filename = remoteURL.pathComponents.last!
                guard let saveDirectory = getDirectoryInDocuments(folder: "svgimage") else {
                    return
                }
                let saveUrl = saveDirectory.appendingPathComponent(filename)
                try! data.write(to: saveUrl, options: .atomic)
                DispatchQueue.main.async {
                    localURL = saveUrl
                }
            }
            task.resume()
        }
    }
}

struct SVGAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        SVGAsyncImage(remoteURL: URL(string: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg")!)
    }
}
