//
//  CategoryCollectionViewCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    let itemLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.text = "item title test"
//        l.backgroundColor = .black
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemSubLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
//        l.backgroundColor = .black
        l.text = "Sub title test"
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemSub2Label: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
        //        l.backgroundColor = .black
        l.text = "Sub title 2 test"
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let labelsStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .vertical
        s.distribution = .equalCentering
        s.spacing = 0
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
        labelsStackView.addArrangedSubview(itemLabel)
        labelsStackView.addArrangedSubview(itemSubLabel)
        labelsStackView.addArrangedSubview(itemSub2Label)

        backgroundColor = Color.lightGray
        layer.cornerRadius = CornerRadius.collectionCell
        layer.masksToBounds = true

        addSubview(labelsStackView)
        addSubview(arrowIcon)

        NSLayoutConstraint.activate([
            arrowIcon.heightAnchor.constraint(equalToConstant: 21),
            arrowIcon.widthAnchor.constraint(equalToConstant: 13),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            labelsStackView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            labelsStackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
