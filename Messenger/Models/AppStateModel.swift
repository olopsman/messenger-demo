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
    
    init(){
        self.showingSignIn = Auth.auth().currentUser == nil
    }
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
        //try to sign in
        //get email from DB
        database.collection("users").document(username).getDocument { [weak self] snapshot, error in
            guard let email = snapshot?.data()?["email"] as? String, error == nil else {
                return
            }
            //try to sign in
            self?.auth.signIn(withEmail: email, password: password, completion: { result, error in
                guard error == nil, result != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.currentUsername = username
                    self?.currentEmail = email
                    self?.showingSignIn = false
                }
            })
        }
     
    }
    
    func signUp(email: String, username: String, password: String) {
        //create account
        auth.createUser(withEmail: email, password: password) {[weak self]result, error in
         guard result != nil, error == nil else {
                return
            }
            //inset username into database
            let data = [
                "email": email,
                "username": username
            ]
            
            self?.database
                .collection("users")
                .document(username)
                .setData(data){ error in
                    guard error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.currentUsername = username
                        self?.currentEmail = email
                        self?.showingSignIn = false
                    }
                }
        }
    }
    
    func signOut(){
        do {
            try auth.signOut()
            DispatchQueue.main.async{
                self.showingSignIn = true
            }
        }
        catch {
            print(error)
        }
    }
}
