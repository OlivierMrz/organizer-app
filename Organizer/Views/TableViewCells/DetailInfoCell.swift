//
//  DetailInfoCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 27/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class DetailInfoCell: UITableViewCell {
    let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge + 4, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let itemSubLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemExtraSubLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let itemStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .vertical
        s.distribution = .equalCentering
        s.spacing = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    let storageLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let storageNumberLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.primaryBackground
        l.backgroundColor = Color.darkGray
        l.layer.cornerRadius = CornerRadius.xSmall
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let placeStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.axis = .vertical
        s.distribution = .fillProportionally
        s.spacing = 3
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    private func setupView() {
        itemStackView.addArrangedSubview(titleLabel)
        itemStackView.addArrangedSubview(itemSubLabel)
        itemStackView.addArrangedSubview(itemExtraSubLabel)

        placeStackView.addArrangedSubview(storageLabel)
        placeStackView.addArrangedSubview(storageNumberLabel)

        addSubview(itemStackView)
        addSubview(placeStackView)

        NSLayoutConstraint.activate([
            itemStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            itemStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            itemStackView.trailingAnchor.constraint(equalTo: placeStackView.leadingAnchor, constant: -10),

            placeStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            placeStackView.widthAnchor.constraint(equalToConstant: 74),
            placeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            storageLabel.heightAnchor.constraint(equalToConstant: 22),

            storageNumberLabel.heightAnchor.constraint(equalToConstant: 37),
            storageNumberLabel.widthAnchor.constraint(equalToConstant: 37),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
