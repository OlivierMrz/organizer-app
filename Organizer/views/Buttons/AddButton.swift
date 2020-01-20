//
//  AddButton.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    func setup() {
        backgroundColor = .clear

        layer.cornerRadius = CornerRadius.small
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Color.blue

        let title = UILabel()
        title.text = "+"
        title.textColor = Color.white
        title.font = UIFont.systemFont(ofSize: 32, weight: FontWeight.regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)

        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()

        heightAnchor.constraint(equalToConstant: 50).isActive = true
        widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
