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
    
//    func roundedCorner(side: c) {
//        if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
//        if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
//        if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
//        if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
//    }

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
        layer.cornerRadius = CornerRadius.large
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func setup() {
        layer.cornerRadius = CornerRadius.xSmall
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(icon: Bool = false, iconImage: UIImage = UIImage(), title: String, backgroundColor: UIColor, borderColor: UIColor, hasRoundedBorder: Bool = true) {
        self.init()
        
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
        
        if hasRoundedBorder {
            layer.cornerRadius = CornerRadius.xSmall
        } else {
            layer.cornerRadius = 0
        }
        
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
