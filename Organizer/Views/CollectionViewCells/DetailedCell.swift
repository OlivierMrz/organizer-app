//
//  DetailedCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class DetailedCell: UICollectionViewCell {
    let itemLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemSubLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemSub2Label: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.font = UIFont.systemFont(ofSize: FontSize.xxSmall, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .vertical
        s.distribution = .equalSpacing
        s.spacing = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    let placeLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let placeStorageLabel: UILabel = {
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func setupView() {
        itemStackView.addArrangedSubview(itemLabel)
        itemStackView.addArrangedSubview(itemSubLabel)
        itemStackView.addArrangedSubview(itemSub2Label)

        placeStackView.addArrangedSubview(placeLabel)
        placeStackView.addArrangedSubview(placeStorageLabel)

        backgroundColor = Color.lightGray
        layer.cornerRadius = CornerRadius.collectionCell
        layer.masksToBounds = true

        addSubview(itemStackView)
        addSubview(placeStackView)
        addSubview(arrowIcon)

        NSLayoutConstraint.activate([
            arrowIcon.heightAnchor.constraint(equalToConstant: 21),
            arrowIcon.widthAnchor.constraint(equalToConstant: 13),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            itemStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            itemStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            itemStackView.trailingAnchor.constraint(equalTo: placeStackView.leadingAnchor, constant: -10),

            placeStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            placeStackView.widthAnchor.constraint(equalToConstant: 74),
            placeStackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -14),

            placeLabel.heightAnchor.constraint(equalToConstant: 22),

            placeStorageLabel.heightAnchor.constraint(equalToConstant: 37),
            placeStorageLabel.widthAnchor.constraint(equalToConstant: 37),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
