//
//  SendButton.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI

struct SendButton: View {
    @Binding var text: String
    var body: some View {
        Button(action: {
            self.sendMessage()
        }, label: {
            Image(systemName: "paperplane")
                .aspectRatio(contentMode: .fit)
                .font(.system(size: 33))
                .frame(width:55, height: 55)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .clipShape(Circle())
            
        })
    }
    func sendMessage() {
        guard !text.isEmpty else {
            return
        }
    }
}

//struct SendButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SendButton()
//    }
//}
