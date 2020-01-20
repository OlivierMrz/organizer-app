//
//  CustomCollectionViewCellWithIcon.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomCollectionViewCellWithIcon: UICollectionViewCell {

    let icon: UIImageView = {
        let i = UIImageView()
//        i.backgroundColor = .black
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    let categoryLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
//        l.text = "Cat test"
//        l.backgroundColor = .black
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    let catItemCountLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.midGray
//        l.backgroundColor = .black
        l.text = "12 items"
        l.font = UIFont.systemFont(ofSize: FontSize.xxSmall, weight: FontWeight.regular)
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

        labelsStackView.addArrangedSubview(categoryLabel)
        labelsStackView.addArrangedSubview(catItemCountLabel)

        backgroundColor = Color.lightGray
        layer.cornerRadius = CornerRadius.collectionCell
        layer.masksToBounds = true

        addSubview(icon)
        addSubview(labelsStackView)
        addSubview(arrowIcon)

        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 80),
            icon.widthAnchor.constraint(equalToConstant: 80),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            arrowIcon.heightAnchor.constraint(equalToConstant: 21),
            arrowIcon.widthAnchor.constraint(equalToConstant: 13),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            labelsStackView.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            labelsStackView.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -10)
        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
