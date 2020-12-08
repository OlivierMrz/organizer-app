//
//  AddButton.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class AddButton: UIButton {
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CornerRadius.medium).cgPath
            shadowLayer.fillColor = Color.primary?.cgColor

            shadowLayer.shadowColor = Color.primary?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = 3

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    func setup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.text = "+"
        title.textColor = Color.primaryBackground
        title.font = UIFont.systemFont(ofSize: 36, weight: FontWeight.regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)

        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3),
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
