//
//  CustomCollectionViewCellWithIcon.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomCollectionViewCellWithIcon: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    func setupView() {
        backgroundColor = Color.lightGray
        contentView.layer.cornerRadius = CornerRadius.medium
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
