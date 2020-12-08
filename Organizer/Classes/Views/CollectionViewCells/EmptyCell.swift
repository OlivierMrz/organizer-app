//
//  EmptyCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 22/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    let title: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let addIcon: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "add-icon")
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    func setupView() {
        backgroundColor = Color.lightGray
        layer.cornerRadius = CornerRadius.collectionCell
        layer.masksToBounds = true

        addSubview(title)
        addSubview(addIcon)

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            addIcon.heightAnchor.constraint(equalToConstant: 24),
            addIcon.widthAnchor.constraint(equalToConstant: 24),
            addIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            addIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
