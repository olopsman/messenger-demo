//
//  SignInView.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI

struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var model: AppStateModel
    
    var body: some View {
        NavigationView {
            VStack {
                //heading
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                //textfields
                
                Text("Messenger")
                    .bold()
                    .font(.system(size: 34))
                //sign up
                VStack{
                    TextField("Username", text: $username)
                        .modifier(CustomField())
                    SecureField("Password", text: $password)
                        .modifier(CustomField())
                    
                    Button(action: {self.signIn()}, label: {
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 220, height: 50)
                            .background(Color.blue)
                            .cornerRadius(6)
                    })
                    
                }.padding()
                Spacer()
                
                //sign up
                HStack {
                    Text("New to Messenger")
                    NavigationLink("Create Account", destination: SignUpView())
                }
            }
        }
    }
    
    func signIn() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
                return
              }
        model.signIn(username: username, password: password)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.dark)
    }
}
