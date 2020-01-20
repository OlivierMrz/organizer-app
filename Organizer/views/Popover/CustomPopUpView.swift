//
//  CustomPopUpView.swift
//  CustomPopUpController
//
//  Created by Olivier Miserez on 13/12/2019.
//  Copyright © 2019 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class CustomPopUpView: UIView, Modal {
    var id: Int?
    var backgroundView = UIView()
    var dialogView = UIView()

    var fullname: String?
    var job: String?

    convenience init(id: Int, name: String, title: String, loc: String) {
        self.init(frame: UIScreen.main.bounds)
        self.id = (id + 1)
        self.fullname = name
        self.job = title
        initialize(name: name, title: title, loc: loc)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize(name: String, title: String, loc: String) {
//        guard let id = id else { return }

        let initials = getInitialsFrom(fullName: name)

        let dialogViewWidth = frame.width - 64
        dialogView.clipsToBounds = true

        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)

        dialogView.backgroundColor = UIColor(red: 255 / 255, green: 199 / 255, blue: 3 / 255, alpha: 1)
        dialogView.layer.cornerRadius = 13
        dialogView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dialogView)
        NSLayoutConstraint.activate([
            dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth),
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
            dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
        ])

        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        closeButton.clipsToBounds = true
        closeButton.setImage(UIImage(named: "cancel"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 18),
            closeButton.widthAnchor.constraint(equalToConstant: 18),
            closeButton.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 22),
            closeButton.rightAnchor.constraint(equalTo: dialogView.rightAnchor, constant: -22)
        ])

        let initialsLabel = UILabel()
        initialsLabel.text = initials
        initialsLabel.font = initialsLabel.font.withSize(38)
        initialsLabel.textColor = .black
        initialsLabel.textAlignment = .center
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.layer.cornerRadius = 50
        initialsLabel.backgroundColor = .white
        initialsLabel.clipsToBounds = true
        initialsLabel.textColor = .black
        dialogView.addSubview(initialsLabel)
        NSLayoutConstraint.activate([
            initialsLabel.widthAnchor.constraint(equalToConstant: 100),
            initialsLabel.heightAnchor.constraint(equalToConstant: 100),
            initialsLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 20),
            initialsLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
        ])

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textAlignment = .left
        nameLabel.sizeToFit()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: initialsLabel.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -24),
        ])

        let jobLabel = UILabel()
        jobLabel.text = title
        jobLabel.textAlignment = .left
        jobLabel.sizeToFit()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(jobLabel)
        NSLayoutConstraint.activate([
            jobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            jobLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            jobLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -24),
        ])

        let locLabel = UILabel()
        locLabel.text = loc
        locLabel.textAlignment = .left
        locLabel.sizeToFit()
        locLabel.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(locLabel)
        NSLayoutConstraint.activate([
            locLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            locLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            locLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -24)
        ])

        let button1 = UIButton()
        button1.setTitle("1", for: .normal)
        button1.clipsToBounds = true
        button1.layer.cornerRadius = 13
        button1.setTitleColor(.black, for: .normal)
        button1.backgroundColor = .white
        button1.translatesAutoresizingMaskIntoConstraints = false

        let button2 = UIButton()
        button2.setTitle("2", for: .normal)
        button2.clipsToBounds = true
        button2.layer.cornerRadius = 13
        button2.setTitleColor(.black, for: .normal)
        button2.backgroundColor = .white
        button2.translatesAutoresizingMaskIntoConstraints = false

        let button3 = UIButton()
        button3.setTitle("3", for: .normal)
        button3.clipsToBounds = true
        button3.layer.cornerRadius = 13
        button3.setTitleColor(.black, for: .normal)
        button3.backgroundColor = .white
        button3.translatesAutoresizingMaskIntoConstraints = false

        let button4 = UIButton()
        button4.setTitle("4", for: .normal)
        button4.clipsToBounds = true
        button4.layer.cornerRadius = 13
        button4.setTitleColor(.black, for: .normal)
        button4.backgroundColor = .white
        button4.translatesAutoresizingMaskIntoConstraints = false

        let button5 = UIButton()
        button5.setTitle("5", for: .normal)
        button5.clipsToBounds = true
        button5.layer.cornerRadius = 13
        button5.setTitleColor(.black, for: .normal)
        button5.backgroundColor = .white
        button5.translatesAutoresizingMaskIntoConstraints = false

        let buttonSize: CGFloat = 45
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: buttonSize),
            button1.heightAnchor.constraint(equalToConstant: buttonSize),
            button2.widthAnchor.constraint(equalToConstant: buttonSize),
            button2.heightAnchor.constraint(equalToConstant: buttonSize),
            button3.widthAnchor.constraint(equalToConstant: buttonSize),
            button3.heightAnchor.constraint(equalToConstant: buttonSize),
            button4.widthAnchor.constraint(equalToConstant: buttonSize),
            button4.heightAnchor.constraint(equalToConstant: buttonSize),
            button5.widthAnchor.constraint(equalToConstant: buttonSize),
            button5.heightAnchor.constraint(equalToConstant: buttonSize)
        ])

        let SocialSV = UIStackView()
        SocialSV.axis = NSLayoutConstraint.Axis.horizontal
        SocialSV.distribution = UIStackView.Distribution.equalSpacing
        SocialSV.alignment = UIStackView.Alignment.center
        SocialSV.spacing = 5.0
        SocialSV.addArrangedSubview(button1)
        SocialSV.addArrangedSubview(button2)
        SocialSV.addArrangedSubview(button3)
        SocialSV.addArrangedSubview(button4)
        SocialSV.addArrangedSubview(button5)
        SocialSV.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(SocialSV)

        NSLayoutConstraint.activate([
            SocialSV.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 32),
            SocialSV.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            SocialSV.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -24)
        ])

        let shareButton = UIButton()
        shareButton.setTitle("SHARE CONTACT", for: .normal)
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = 13
        shareButton.setTitleColor(.black, for: .normal)
        shareButton.backgroundColor = .white
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        dialogView.addSubview(shareButton)

        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: SocialSV.bottomAnchor, constant: 16),
            shareButton.heightAnchor.constraint(equalToConstant: buttonSize),
            shareButton.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            shareButton.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -24),
            shareButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -20),
        ])
    }

    @objc func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }

    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
}

func getInitialsFrom(fullName: String) -> String {
    var initials = ""
    let x = fullName.split(separator: " ")
    for i in x {
        let first = i.prefix(1)
        initials += first
    }

    return initials.uppercased()
}

