//
//  InviteFriend.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import SwiftUI

struct InviteFriend: View {
    
    @State var isPresentedActivityView = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.inviteFriendBackground)
            .overlay(content)
            .frame(height: 82)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                isPresentedActivityView = true
            }
            .sheet(isPresented: $isPresentedActivityView) {
                ShareActivityView(activityItems: [URL(string: "https://careers.lmwn.com")!])
            }
    }
    
    var presentIcon: some View {
        Circle()
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .overlay(
                Image("Component/Present")
            )
    }
    
    var content: some View {
        HStack(spacing: 16) {
            presentIcon
            (
                Text("You can earn $10 when you invite a friend to buy crypto. ") +
                Text("Invite your friend")
                    .fontWeight(.semibold)
                    .foregroundColor(.inviteYourFriend)
            )
            .lineLimit(3)
            .font(.subheadline)
            .minimumScaleFactor(0.6)
        }
        .padding(.vertical, 21)
        .padding(.horizontal, 16)
    }
}

struct InviteFriend_Previews: PreviewProvider {
    
    static var paddingSize: CGFloat = 20
    
    static var previews: some View {
        InviteFriend()
            .previewDisplayName("Invite Friend")
            .previewLayout(.fixed(width: 359, height: 82))
        
        InviteFriend()
            .previewDisplayName("Invite Friend Small")
            .previewLayout(.fixed(width: 245, height: 82))
    }
}
