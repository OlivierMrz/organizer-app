//
//  CustomButton.swift
//  Organizer
//
//  Created by Olivier Miserez on 15/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    func setup(title: String, backgroundColor: UIColor, borderColor: UIColor) {
        self.setTitle(title, for: .normal)

        if backgroundColor == Color.blue {
            self.setTitleColor(Color.white, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: FontWeight.bold)
        } else {
            self.setTitleColor(Color.blue, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: FontWeight.medium)
        }


        self.backgroundColor = backgroundColor
        self.layer.borderWidth = BorderWidth.large
        self.layer.borderColor = borderColor.cgColor
    }

    func setup() {
        layer.cornerRadius = CornerRadius.xSmall
        layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
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
