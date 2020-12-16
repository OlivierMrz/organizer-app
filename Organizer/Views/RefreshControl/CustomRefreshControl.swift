//
//  CustomRefreshControl.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {
    
    private func setup() {
        backgroundColor = .white
        tintColor = Color.primary
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: FontSize.xSmall),
            .foregroundColor: Color.primary,
        ]
        attributedTitle = NSAttributedString(string: "Fetching data", attributes: attributes)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
