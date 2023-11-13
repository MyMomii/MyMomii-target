//
//  AuthenticationView.swift
//  MyMomii
//
//  Created by qwd on 11/13/23.
//

import FirebaseAuth
import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    var body: some View {
        VStack {
            Text("You're logged in with ID: \(Auth.auth().currentUser?.uid ?? "")")
                .onAppear(perform: authModel.listenToAuthState)
            Button(action: { authModel.signInAnonymously()
            }) {
                HStack {
                    Image(systemName: "person.circle")
                        .font(.title)
                    Text("Sign in anonymously")
                        .fontWeight(.semibold)
                        .font(.callout)
                }
            }
            Button(action: { authModel.signOut()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title)
                    Text("Sign Out")
                        .fontWeight(.semibold)
                        .font(.callout)
                }
            }
        }
    }
}

#Preview {
    AuthenticationView()
}
