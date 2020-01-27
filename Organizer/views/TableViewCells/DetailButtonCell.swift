//
//  DetailButtonCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 27/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class DetailButtonCell: UITableViewCell {
    var lentOutButton: CustomButton = {
        let b = CustomButton()

        return b
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    func setupView() {
        addSubview(lentOutButton)

        NSLayoutConstraint.activate([
            lentOutButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            lentOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            lentOutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            lentOutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
