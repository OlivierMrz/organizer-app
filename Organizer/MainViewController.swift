//
//  MainViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let test = Auth.auth().currentUser?.email
        if test != nil {
            let x = UserDefaults.standard
            x.set(test!, forKey: "lastLoggedInUser")
            x.synchronize()
            print(test!)
        } else {
            print(test ?? "no user")
        }

        let x = UserDefaults.standard.bool(forKey: "userSignedIn")
        if !x {
            let y = LoginViewController()
            y.modalPresentationStyle = .fullScreen
            present(y, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.lightGray

        let barButtonLeft = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonLeft
    }

    @IBAction func leftBarButtonTapped() {
        do {
            try Auth.auth().signOut()
            let userDefault = UserDefaults.standard
            userDefault.set(false, forKey: "userSignedIn")
            userDefault.synchronize()

            let y = LoginViewController()
            y.modalPresentationStyle = .fullScreen

            self.present(y, animated: true, completion: nil)
        } catch let err {
                print(err)
        }
    }

}
