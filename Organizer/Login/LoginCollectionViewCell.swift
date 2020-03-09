//
//  LoginCollectionViewCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 15/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class LoginCollectionViewCell: UICollectionViewCell {
    let bigLoginTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Hello"
        l.textColor = Color.primaryBackground
        l.font = UIFont.systemFont(ofSize: FontSize.TitleBig, weight: FontWeight.bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let smallLoginTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Sign in to your account"
        l.textColor = Color.primaryBackground
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.primaryBackground
        v.layer.cornerRadius = CornerRadius.xxLarge
        v.layer.maskedCorners = [.layerMinXMinYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let emailLabel: UILabel = {
        let l = UILabel()
        l.text = "Email"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.regular)
        l.sizeToFit()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let emailTextField: CustomTextField = {
        let t = CustomTextField()
        t.setup(placeHolder: "your@email.com")
        t.text = "test@test.com"
        return t
    }()

    let passwordLabel: UILabel = {
        let l = UILabel()
        l.text = "Password"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let passwordTextField: CustomTextField = {
        let t = CustomTextField()
        t.setup(placeHolder: "******")
        t.isSecureTextEntry = true
        t.text = "123456"
        return t
    }()

    let forgotPasswordButton: UIButton = {
        let b = UIButton()
        b.setTitle("Forgot password?", for: .normal)
        b.setTitleColor(Color.midGray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.xxSmall, weight: FontWeight.regular)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.sizeToFit()
        return b
    }()

    let signInButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "SIGN IN", backgroundColor: Color.primary!, borderColor: Color.primary!)
        return b
    }()

    let registerButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "REGISTER ACCOUNT", backgroundColor: Color.primaryBackground!, borderColor: Color.primary!)
        return b
    }()

    weak var textFieldDelegate: CollectionCellTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        signInButton.addTarget(self, action: #selector(signinButtonTapped), for: .touchUpInside)
    }

    func setupViews() {
        contentView.addSubview(bigLoginTitleLabel)
        contentView.addSubview(smallLoginTitleLabel)
        contentView.addSubview(mainView)

        mainView.addSubview(emailLabel)
        mainView.addSubview(emailTextField)
        mainView.addSubview(passwordLabel)
        mainView.addSubview(passwordTextField)
        mainView.addSubview(forgotPasswordButton)
        mainView.addSubview(signInButton)
        mainView.addSubview(registerButton)

        if Device.IS_IPAD {
            NSLayoutConstraint.activate([
                bigLoginTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitle),
                bigLoginTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 74),
                mainView.topAnchor.constraint(equalTo: smallLoginTitleLabel.bottomAnchor, constant: 54),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.xLarge),
                emailLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 54),
            ])
        } else if Device.IS_IPHONE_6P_OR_GREATHER {
            NSLayoutConstraint.activate([
                bigLoginTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitle),
                bigLoginTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
                mainView.topAnchor.constraint(equalTo: smallLoginTitleLabel.bottomAnchor, constant: 54),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large),
                emailLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 54),
            ])
        } else {
            NSLayoutConstraint.activate([
                bigLoginTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitleSmallScreen),
                bigLoginTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
                mainView.topAnchor.constraint(equalTo: smallLoginTitleLabel.bottomAnchor, constant: 24),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large),
                emailLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 30),
            ])
        }

        NSLayoutConstraint.activate([
            bigLoginTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 46),

            smallLoginTitleLabel.topAnchor.constraint(equalTo: bigLoginTitleLabel.bottomAnchor, constant: Margins.small),
            smallLoginTitleLabel.trailingAnchor.constraint(equalTo: bigLoginTitleLabel.trailingAnchor, constant: 0),
            smallLoginTitleLabel.leadingAnchor.constraint(equalTo: bigLoginTitleLabel.leadingAnchor, constant: 0),

            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            emailLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -36),
            emailLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 36),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: Margins.small),
            emailTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 0),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor, constant: -2),
            emailTextField.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 18),
            passwordLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 0),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor, constant: 0),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: Margins.small),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor, constant: -2),
            passwordTextField.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 2),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 0),

            signInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: Margins.xLarge),
            signInButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 0),
            signInButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 0),
            signInButton.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            registerButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: Margins.medium),
            registerButton.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: 0),
            registerButton.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor, constant: 0),
            registerButton.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

        ])
    }

    @IBAction func signinButtonTapped() {
        guard let textFieldDelegate = textFieldDelegate else { return }
        textFieldDelegate.textDidChangeLoginScreen([emailTextField, passwordTextField])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
