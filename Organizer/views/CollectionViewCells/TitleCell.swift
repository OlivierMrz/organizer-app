//
//  TitleCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 23/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class TitleCell: UICollectionViewCell {
    let title: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let storagePlaceLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let storageNumberLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.white
        l.backgroundColor = Color.darkGray
        l.layer.cornerRadius = CornerRadius.xSmall
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let placeStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.axis = .vertical
        s.distribution = .fillProportionally
        s.spacing = 3
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    let arrowIcon: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "arrow-right")
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    func setupView() {
        backgroundColor = Color.lightGray
        layer.cornerRadius = CornerRadius.collectionCell
        layer.masksToBounds = true

        placeStackView.addArrangedSubview(storagePlaceLabel)
        placeStackView.addArrangedSubview(storageNumberLabel)

        addSubview(title)
        addSubview(placeStackView)
        addSubview(arrowIcon)

        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            placeStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            placeStackView.widthAnchor.constraint(equalToConstant: 74),
            placeStackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -14),

            storagePlaceLabel.heightAnchor.constraint(equalToConstant: 22),

            storageNumberLabel.heightAnchor.constraint(equalToConstant: 37),
            storageNumberLabel.widthAnchor.constraint(equalToConstant: 37),

            arrowIcon.heightAnchor.constraint(equalToConstant: 21),
            arrowIcon.widthAnchor.constraint(equalToConstant: 13),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

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
