//
//  SignUpView.swift
//  Messenger
//
//  Created by Paulo Orquillo on 24/04/21.
//

import SwiftUI

struct SignUpView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject var model: AppStateModel
    
    var body: some View {
            VStack {
                //heading
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                
                //sign up
                VStack{
                    TextField("Email Address", text: $email)
                        .modifier(CustomField())
                    TextField("Username", text: $username)
                        .modifier(CustomField())
                    SecureField("Password", text: $password)
                        .modifier(CustomField())
                    
                    Button(action: {self.signUp()}, label: {
                        Text("Sign Up")
                            .foregroundColor(Color.white)
                            .frame(width: 220, height: 50)
                            .background(Color.green)
                            .cornerRadius(6)
                    })
                    
                }.padding()
                Spacer()
                
            }.navigationBarTitle("Create Account", displayMode: .inline)
    }
    
    func signUp() {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
                return
              }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
