//
//  PopoverLabel.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class PopoverLabel: UILabel {
    func setup() {
        backgroundColor = .clear
        textColor = Color.primary
        font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(title: String) {
        self.init()
        text = title
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
