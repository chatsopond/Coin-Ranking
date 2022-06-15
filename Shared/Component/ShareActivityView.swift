//
//  ShareActivityView.swift
//  LMWN Coin
//
//  Created by Chatsopon Deepateep on 11/6/2565 BE.
//

import SwiftUI

/// Show `UIActivityViewController`
struct ShareActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

struct ShareActivityView_Preview: PreviewProvider {
    static var previews: some View {
        Text("Test")
            .sheet(isPresented: .constant(true),
                   onDismiss: nil) {
                ShareActivityView(activityItems: [URL(string: "https://www.apple.com/")!])
            }
    }
}
