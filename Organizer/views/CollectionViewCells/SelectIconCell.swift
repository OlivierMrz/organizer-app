//
//  SelectIconCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 21/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class SelectIconCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    func setupView() {
        layer.cornerRadius = CornerRadius.medium
        layer.masksToBounds = true

        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
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
