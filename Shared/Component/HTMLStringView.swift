//
//  HTMLStringView.swift
//  LMWN Coin
//
//  Created by Chatsopon Deepateep on 10/6/2565 BE.
//  Original: https://stackoverflow.com/questions/56892691/how-to-show-html-or-markdown-in-a-swiftui-text
//

import WebKit
import SwiftUI

/// Return a view that displays interactive web content from `htmlString`
struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let headerString = "<head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></head>"
        uiView.loadHTMLString(
            headerString + "<body style=\"font-family: -apple-system\">" + htmlContent + "</body>",
            baseURL: nil)
        uiView.scrollView.showsVerticalScrollIndicator = false
    }
}
