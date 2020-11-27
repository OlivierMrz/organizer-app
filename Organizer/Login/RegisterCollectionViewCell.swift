//
//  RegisterCollectionViewCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol CollectionCellTextFieldDelegate: class {
    func textDidChangeRegisterScreen(_ textField: [UITextField])
    func textDidChangeLoginScreen(_ textField: [UITextField])
}

class RegisterCollectionViewCell: UICollectionViewCell {
    private let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.primaryBackground
//        v.layer.cornerRadius = CornerRadius.xxLarge
//        v.layer.maskedCorners = [.layerMinXMaxYCorner]
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let bigRegisterTitleLabel1: UILabel = {
        let l = UILabel()
        l.text = "Hello"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.TitleBig, weight: FontWeight.bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let bigRegisterTitleLabel2: UILabel = {
        let l = UILabel()
        l.text = "again..."
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.bold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let smallRegisterTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Create your account"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let emailLabel: UILabel = {
        let l = UILabel()
        l.text = "Email"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.regular)
        l.sizeToFit()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let emailTextField: CustomTextField = {
        let t = CustomTextField()
        t.setup(placeHolder: "your@email.com")
        return t
    }()

    private let passwordLabel: UILabel = {
        let l = UILabel()
        l.text = "Password"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let passwordTextField: CustomTextField = {
        let t = CustomTextField()
        t.setup(placeHolder: "******")
        t.isSecureTextEntry = true
        t.textContentType = .newPassword
        return t
    }()

    private let confirmPasswordLabel: UILabel = {
        let l = UILabel()
        l.text = "Confirm password"
        l.textColor = Color.primary
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let confirmPasswordTextField: CustomTextField = {
        let t = CustomTextField()
        t.setup(placeHolder: "******")
        t.isSecureTextEntry = true
        t.textContentType = .newPassword
        return t
    }()

    let scrollToLoginButton: UIButton = {
        let b = UIButton()
        b.setTitle("Go to signin", for: .normal)
        b.setTitleColor(Color.midGray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.xxSmall, weight: FontWeight.regular)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.sizeToFit()
        return b
    }()

    private let registerAccountButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Create account", backgroundColor: Color.primary!, borderColor: Color.primary!)
        return b
    }()

    weak var textFieldDelegate: CollectionCellTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

        registerAccountButton.addTarget(self, action: #selector(registerAccountButtonTapped), for: .touchUpInside)
    }

    private func setupViews() {
        contentView.addSubview(mainView)

        let views = [
            bigRegisterTitleLabel1,
            bigRegisterTitleLabel2,
            smallRegisterTitleLabel,
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            confirmPasswordLabel,
            confirmPasswordTextField,
            registerAccountButton,
            scrollToLoginButton,
        ]

        addSubViews(views, to: mainView)
        if Device.IS_IPAD {
            NSLayoutConstraint.activate([
                bigRegisterTitleLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitle),
                bigRegisterTitleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 74),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.xLarge),
                emailLabel.topAnchor.constraint(equalTo: smallRegisterTitleLabel.topAnchor, constant: 74),
            ])
        } else if Device.IS_IPHONE_6P_OR_GREATHER {
            NSLayoutConstraint.activate([
                bigRegisterTitleLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitle),
                bigRegisterTitleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large),
                emailLabel.topAnchor.constraint(equalTo: smallRegisterTitleLabel.bottomAnchor, constant: 54),
            ])
        } else {
            NSLayoutConstraint.activate([
                bigRegisterTitleLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Margins.bigTitleSmallScreen),
                bigRegisterTitleLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 46),
                mainView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Margins.large),
                emailLabel.topAnchor.constraint(equalTo: smallRegisterTitleLabel.bottomAnchor, constant: 30),
            ])
        }

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            mainView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),

            bigRegisterTitleLabel2.bottomAnchor.constraint(equalTo: bigRegisterTitleLabel1.bottomAnchor, constant: -12),
            bigRegisterTitleLabel2.leadingAnchor.constraint(equalTo: bigRegisterTitleLabel1.trailingAnchor, constant: -12),

            smallRegisterTitleLabel.topAnchor.constraint(equalTo: bigRegisterTitleLabel1.bottomAnchor, constant: Margins.small),
            smallRegisterTitleLabel.trailingAnchor.constraint(equalTo: bigRegisterTitleLabel1.trailingAnchor, constant: 0),
            smallRegisterTitleLabel.leadingAnchor.constraint(equalTo: bigRegisterTitleLabel1.leadingAnchor, constant: 0),

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
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 0),
            passwordTextField.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 18),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 0),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor, constant: 0),

            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: Margins.small),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: 0),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 0),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            registerAccountButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: Margins.xLarge),
            registerAccountButton.trailingAnchor.constraint(equalTo: confirmPasswordTextField.trailingAnchor, constant: 0),
            registerAccountButton.leadingAnchor.constraint(equalTo: confirmPasswordTextField.leadingAnchor, constant: 0),
            registerAccountButton.heightAnchor.constraint(equalToConstant: Margins.xxxLarge),

            scrollToLoginButton.topAnchor.constraint(equalTo: registerAccountButton.bottomAnchor, constant: 2),
            scrollToLoginButton.trailingAnchor.constraint(equalTo: registerAccountButton.trailingAnchor, constant: 0),
        ])
    }

    @IBAction private func registerAccountButtonTapped() {
        guard let textFieldDelegate = textFieldDelegate else { return }
        textFieldDelegate.textDidChangeRegisterScreen([emailTextField, passwordTextField, confirmPasswordTextField])
    }

    private func addSubViews(_ views: [UIView], to parentView: UIView) {
        views.forEach { parentView.addSubview($0) }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
