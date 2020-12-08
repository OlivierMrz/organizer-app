//
//  LoginViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, CollectionCellTextFieldDelegate {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Color.primary
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private var userViewModel: UserViewModel?
    private var users: [User]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.primary
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(LoginCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.loginCell)
        collectionView.register(RegisterCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.registerCell)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
//        collectionView.isScrollEnabled = false
//        collectionView.automaticallyAdjustsScrollIndicatorInsets = false // --- ios 13
        collectionView.contentInsetAdjustmentBehavior = .never

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        let viewTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(viewTap)
    }

    // MARK: LoginScreen button tapped
    internal func textDidChangeLoginScreen(_ textField: [UITextField]) {
        var message = ""
        if textField[0].text!.isEmpty {
            message = "Email is empty"
        } else if textField[1].text!.isEmpty {
            message = "Password is empty"
        }

        guard message.isEmpty else {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            present(alertController, animated: true, completion: nil)
            return
        }

        guard let email = textField[0].text,
            let password = textField[1].text else {
            return
        }


//        ref.observeSingleEvent(of: .value, with: { snapshot in
//
////            print("snapshot:", snapshot)
//            var tempUsers: [User] = []
//
//            if snapshot.childrenCount > 0 {
//                for child in snapshot.children {
//
////                    print("child:", child)
//
//                    if let snapshot = child as? DataSnapshot,
//                        let users = User(snapshot: snapshot) {
//
//                        tempUsers.append(users)
//
//                    }
//
//                }
//            }
//
//            self.users = tempUsers
//
//        })
    }

    // MARK: RegisterScreen button tapped
    internal func textDidChangeRegisterScreen(_ textField: [UITextField]) {
        var message = ""
        if textField[0].text!.isEmpty {
            message = "Email is empty"
        } else if textField[1].text!.isEmpty {
            message = "Password is empty"
        } else if textField[2].text!.isEmpty {
            message = "Confirm password is empty"
        }

        guard message.isEmpty else {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            present(alertController, animated: true, completion: nil)
            return
        }

        guard let email = textField[0].text,
            let password = textField[1].text,
            let confirmPassword = textField[2].text else { return }

        if password != confirmPassword {
            message = "Password is not the same as confirm password"
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            present(alertController, animated: true, completion: nil)
            return
        }

    }

    @IBAction private func viewTapped() {
        view.endEditing(true)
    }

    @IBAction private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 20, right: 0)
        }

//        collectionView.scrollIndicatorInsets = yourTextView.contentInset
//        let selectedRange = collectionView.selectedRange
//        collectionView.scrollRangeToVisible(selectedRange)
    }

    @IBAction private func loginCellregisterAccountButtonTapped() {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .bottom, animated: true)
    }

    @IBAction private func scrollToLoginButtonTapped() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .bottom, animated: true)
    }
}

extension LoginViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.loginCell, for: indexPath) as! LoginCollectionViewCell
            loginCell.registerButton.addTarget(self, action: #selector(loginCellregisterAccountButtonTapped), for: .touchUpInside)
            loginCell.textFieldDelegate = self
            return loginCell
        } else {
            let registerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.registerCell, for: indexPath) as! RegisterCollectionViewCell
            registerCell.scrollToLoginButton.addTarget(self, action: #selector(scrollToLoginButtonTapped), for: .touchUpInside)
            registerCell.textFieldDelegate = self
            return registerCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
