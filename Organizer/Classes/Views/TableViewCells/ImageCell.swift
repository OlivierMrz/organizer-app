//
//  DetailImageCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 27/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class DetailImageCell: UITableViewCell {
    private let imageview: UIImageView = {
        let i = UIImageView()
        i.backgroundColor = Color.lightGray
        i.contentMode = .scaleAspectFit
        i.image = UIImage(named: "placeholder")
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    func setupView(imageid: Data? = nil) {
        addSubview(imageview)

        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
        guard let imageData = imageid else { return }
        
        DispatchQueue.main.async {
            self.imageview.image = UIImage(data: imageData)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
