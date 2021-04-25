//
//  ContentView.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI

struct ConversationListView: View {
    let usernames = ["Joe", "Jill", "Bob"]
    @EnvironmentObject var model: AppStateModel
    
    @State var otherUsername: String = ""
    @State var showChat: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(usernames, id: \.self) {name in
                    NavigationLink(
                        destination: ChatView(otherUsername: name),
                        label: {
                            HStack {
                                Circle()
                                    .frame(width: 65, height: 65)
                                    .foregroundColor(Color.pink)
                                Text(name)
                                    .bold()
                                    .foregroundColor(Color(.label))
                                    .font(.system(size: 32))
                                Spacer()
                            }.padding()
                        })
                }
                
                if !otherUsername.isEmpty {
                    NavigationLink("", destination: ChatView(otherUsername: otherUsername), isActive: $showChat)
                }
            }.navigationTitle("Conversations")
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button(action: {
                        self.signOut()
                    },
                           label: {
                        Text("Sign Out")
                    })
                }
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    NavigationLink(
                        destination: SearchView{name in
                            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                                self.otherUsername = name
                                self.showChat = true
                            }
                        },
                        label: {
                            Image(systemName: "magnifyingglass")
                        })
                }
            }
            .fullScreenCover(isPresented: $model.showingSignIn, content: {
                SignInView()
            })
        }
    }
    
    func signOut() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView()
    }
}
