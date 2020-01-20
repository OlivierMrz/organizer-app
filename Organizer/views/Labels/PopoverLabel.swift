//
//  PopoverLabel.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class PopoverLabel: UILabel {

    func setup(title: String) {
        text = title
    }

    func setup() {
        backgroundColor = .clear
        textColor = Color.blue
        font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false

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
