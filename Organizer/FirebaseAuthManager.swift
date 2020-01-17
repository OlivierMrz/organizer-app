//
//  FirebaseAuthManager.swift
//
//
//  Created by Olivier Miserez on 14/01/2020.
//

import FirebaseAuth
import Foundation

class FirebaseAuthManager {
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true, error)
            } else {
                completionBlock(false, error)
            }
        }
    }

    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { _, error in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false, error)
            } else {
                completionBlock(true, error)
            }
        }
    }
}
