//
//  ItemDetailViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 24/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Color.primaryBackground
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var viewModel: ItemViewModel
    
    init(itemViewModel: ItemViewModel) {
        self.viewModel = itemViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(DetailImageCell.self, forCellReuseIdentifier: ReuseIdentifier.detailImageCell)
        tableView.register(DetailInfoCell.self, forCellReuseIdentifier: ReuseIdentifier.detailInfoCell)
        tableView.register(DetailButtonCell.self, forCellReuseIdentifier: ReuseIdentifier.detailButtonCell)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailImageCell, for: indexPath) as! DetailImageCell
            cell.setupView(imageid: viewModel.image)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailInfoCell, for: indexPath) as! DetailInfoCell
            cell.itemSubLabel.text = viewModel.subTitle
            cell.itemExtraSubLabel.text = viewModel.extraSubTitle
            cell.storageLabel.text = viewModel.storagePlace
            cell.storageNumberLabel.text = viewModel.storageNumber
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
            cell.lentOutButton.setup(title: "Lent out", backgroundColor: Color.primary!, borderColor: Color.primary!)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
            cell.lentOutButton.setup(icon: true, iconImage: UIImage(named: "trash")!,title: "Delete item", backgroundColor: Color.red!, borderColor: Color.red!)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailImageCell, for: indexPath) as! DetailImageCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 240
        case 2, 3:
            return 56
        default:
            return 100
        }
    }
}
