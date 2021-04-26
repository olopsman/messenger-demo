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
    var conversationsListener: ListenerRegistration?
    var chatListener: ListenerRegistration?
    
    init(){
        self.showingSignIn = Auth.auth().currentUser == nil
    }
}
//search
extension AppStateModel {
    func searchUsers(queryText: String, completion: @escaping ([String]) -> Void) {
        database.collection("users").getDocuments {snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({$0.documentID}), error == nil else {
                completion([])
                return
            }
            let filtered = usernames.filter({
                $0.lowercased().hasPrefix(queryText.lowercased())
            })
            completion(filtered)
        }
    }
    
}

//conversations
extension AppStateModel {
    func getConversations() {
        //Listen for conversations
        conversationsListener = database.collection("users").document(currentUsername).collection("chats").addSnapshotListener { [weak self]snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({$0.documentID}), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.conversations = usernames
            }
            
        }
    }
}

//get chat /messages
extension AppStateModel {
    func observeChat() {
        createConversation()
        //Listen for conversations
        chatListener = database.collection("users")
            .document(currentUsername)
            .collection("chats")
            .document(otherUsername)
            .collection("messages")
            .addSnapshotListener { [weak self]snapshot, error in
            guard let objects = snapshot?.documents.compactMap({$0.data()}), error == nil else {
                return
            }
            let messages = objects.compactMap({
                return Message(text: $0["text"] as? String ?? ""
                               , type: $0["sender"] as? String == self?.currentUsername ? .sent : .received
                               , created: ISO8601DateFormatter().date(from: $0["created"] as? String ?? "") ?? Date()
                )
            })
            .sorted(by: {first, second in
                return first.created <  second.created
            })
            DispatchQueue.main.async {
                self?.messages = messages
            }
            
        }
    }
    func sendMessage(text: String) {
        let newMesageId = UUID().uuidString
        
        let data = [
            "text": text,
            "sender": currentUsername,
            "created": ISO8601DateFormatter().string(from: Date())
        ]
        //insert two messages in the database
        database.collection("users")
            .document(currentUsername)
            .collection("chats")
            .document(otherUsername)
            .collection("messages")
            .document(newMesageId)
            .setData(data)
        
        
        database.collection("users")
            .document(otherUsername)
            .collection("chats")
            .document(currentUsername)
            .collection("messages")
            .document(newMesageId)
            .setData(data)
    }
    func createConversation() {
        //create conversation on first user
        database.collection("users")
            .document(currentUsername)
            .collection("chats")
            .document(otherUsername).setData(["created":"true"])

        ///create converstation on other user
        database.collection("users")
            .document(otherUsername)
            .collection("chats")
            .document(currentUsername).setData(["created":"true"])

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
