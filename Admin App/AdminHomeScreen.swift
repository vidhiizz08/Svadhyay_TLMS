//
//  HomeAdminScreen.swift
//  TLMS-admin
//
//  Created by Priyanshu Gupta on 04/07/24.
//

import Foundation
import FirebaseAuth
import SwiftUI

struct AdminHomeScreen: View {
    @EnvironmentObject var authViewModel: UserAuthentication

    var body: some View {
        
        VStack {
            Text("Admin Home Screen")
                .navigationBarBackButtonHidden()
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    authViewModel.signOut()
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                Text("Sign Out")
                    .foregroundColor(.blue)
            }
            .padding(.top, 200)
            
            NavigationLink("", destination: CreateAccountView(), isActive: $authViewModel.isLoggedIn)
        }
    }
}

struct AdminHomeScreen_Preview: PreviewProvider {
    static var previews: some View {
        FirstTimeLogin()
    }
}
