//
//  ItemDetailView.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemDetailView: UIView {

    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Color.primaryBackground
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private func setup() {
        addSubview(tableView)

        tableView.register(DetailImageCell.self, forCellReuseIdentifier: ReuseIdentifier.detailImageCell)
        tableView.register(DetailInfoCell.self, forCellReuseIdentifier: ReuseIdentifier.detailInfoCell)
        tableView.register(DetailButtonCell.self, forCellReuseIdentifier: ReuseIdentifier.detailButtonCell)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
