//
//  ChatView.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI


struct CustomField: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(7)
        
    }
}

struct ChatView: View {
    @State var message: String = ""
    let otherUsername: String
    
    init(otherUsername: String) {
        self.otherUsername = otherUsername
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ChatRow(text: "Hello World", type: .sent)
                    .padding(3)
                ChatRow(text: "Hello Back", type: .received)
                    .padding(3)
            }
            //Field, send button
            HStack {
                TextField("Message...", text: $message)
                    .modifier(CustomField())
                
                SendButton(text: $message)
            }
            .padding()
            
        }.navigationTitle(otherUsername)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(otherUsername: "Samantha")
            .preferredColorScheme(.dark)
    }
}
