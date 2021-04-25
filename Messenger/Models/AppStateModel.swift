//
//  AppStateModel.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AppStateModel: ObservableObject {
    @AppStorage("currentUsername") var currentUsername: String = ""
    @AppStorage("currentEmail")var currentEmail: String = ""

    @Published var showingSignIn: Bool = true
    //current user being chatted with
    @Published var conversations: [String] = []
    @Published var messages: [Message] = []
    
    var database = Firestore.firestore()
    var auth = Auth.auth()
    var otherUsername = ""
    //messages, conversations
}
//search
extension AppStateModel {
    func searchUsers(queryText: String, completion: @escaping ([String]) -> Void) {
        
    }
    
}

//conversations
extension AppStateModel {
    func getConversations() {
        //Listen for conversations
        
    }
}

//get chat /messages
extension AppStateModel {
    func observeChat() {
        
    }
    func sendMessage(text: String) {
        
    }
    func createConversationIfNeeded() {
        
    }
}


//sign in
extension AppStateModel {
    func signIn(username: String, password: String) {
        
    }
    
    func signUp(email: String, username: String, password: String) {
        //create account
        auth.createUser(withEmail: email, password: <#T##String#>, completion: <#T##((AuthDataResult?, Error?) -> Void)?##((AuthDataResult?, Error?) -> Void)?##(AuthDataResult?, Error?) -> Void#>)
        //inset username into database
    }
    
    func signOut(){
        
    }
}
