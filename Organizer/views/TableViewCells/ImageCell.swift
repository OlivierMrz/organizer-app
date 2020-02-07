//
//  DetailImageCell.swift
//  Organizer
//
//  Created by Olivier Miserez on 27/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import FirebaseStorage
import UIKit

class DetailImageCell: UITableViewCell {
    let imageview: UIImageView = {
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

    func setupView(imageid: String? = nil) {
        addSubview(imageview)

        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
        guard let imageId = imageid else { return }

        var tempImage: UIImage? {
            didSet {
                print()
            }
        }
        let storageRef = Storage.storage().reference(withPath: imageId)
        storageRef.downloadURL(completion: { url, err in

            if let err = err {
                print("Unable to retrieve URL due to error: \(err.localizedDescription)")
            }

            if let url = url {
                let data = try? Data(contentsOf: url)
                self.imageview.image = UIImage(data: data!)
            } else {
                self.imageview.image = UIImage(named: "placeholder")
            }

        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
