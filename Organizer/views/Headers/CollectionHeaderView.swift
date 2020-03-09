//
//  CollectionHeaderView.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    let firstLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let secondLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let thirdLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let stackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    func setupHeaderView(titleCount: Int = 1, firstTitle: String, secondTitle: String?, thirdTitle: String?) {
        switch titleCount {
        case 1:
            stackView.addArrangedSubview(firstLabel)
            firstLabel.text = firstTitle

        case 2:
            stackView.addArrangedSubview(firstLabel)
            firstLabel.text = firstTitle
            stackView.addArrangedSubview(secondLabel)
            secondLabel.text = secondTitle

        case 3:
            stackView.addArrangedSubview(firstLabel)
            firstLabel.text = firstTitle
            stackView.addArrangedSubview(secondLabel)
            secondLabel.text = secondTitle
            stackView.addArrangedSubview(thirdLabel)
            thirdLabel.text = thirdTitle

        default:
            fatalError()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = Color.primaryBackground
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
