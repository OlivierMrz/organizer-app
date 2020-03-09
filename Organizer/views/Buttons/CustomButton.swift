//
//  CustomButton.swift
//  Organizer
//
//  Created by Olivier Miserez on 15/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    let iconView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    func setup(icon: Bool = false, iconImage: UIImage = UIImage(), title: String, backgroundColor: UIColor, borderColor: UIColor) {
        setTitle(title, for: .normal)

        if icon {
            iconView.image = iconImage
            addSubview(iconView)
            NSLayoutConstraint.activate([
                iconView.heightAnchor.constraint(equalToConstant: 30),
                iconView.widthAnchor.constraint(equalToConstant: 20),
                iconView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
                iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            ])
        }

        if backgroundColor == Color.primaryBackground {
            setTitleColor(Color.primary, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: FontWeight.medium)
        } else {
            setTitleColor(Color.primaryBackground, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: FontWeight.bold)
        }

        self.backgroundColor = backgroundColor
        layer.borderWidth = BorderWidth.large
        layer.borderColor = borderColor.cgColor
    }

    func setup() {
        layer.cornerRadius = CornerRadius.xSmall
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
