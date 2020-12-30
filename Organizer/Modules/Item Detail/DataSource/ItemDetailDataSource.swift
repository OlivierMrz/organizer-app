//
//  ItemDetailDataSource.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailDataSource: NSObject, UITableViewDataSource {
    
    private var viewModel: ItemViewModel
    
    init(viewModel: ItemViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailInfoCell, for: indexPath) as! DetailInfoCell
            cell.titleLabel.text = viewModel.name.firstUppercased
            cell.itemSubLabel.text = viewModel.subTitle?.firstUppercased
            cell.itemExtraSubLabel.text = viewModel.extraSubTitle?.firstUppercased
            cell.storageLabel.text = viewModel.storagePlace.firstUppercased
            cell.storageNumberLabel.text = viewModel.storageNumber.uppercased()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
            cell.lentOutButton.setup(title: "Lent out", backgroundColor: Color.primary, borderColor: Color.primary)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
            cell.lentOutButton.setup(icon: true, iconImage: UIImage(named: "trash")!,title: "Delete item", backgroundColor: Color.red, borderColor: Color.red)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailImageCell, for: indexPath) as! DetailImageCell
            return cell
        }
        
//        switch indexPath.row {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailImageCell, for: indexPath) as! DetailImageCell
//            cell.setupView(imageid: viewModel.image)
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailInfoCell, for: indexPath) as! DetailInfoCell
//            cell.titleLabel.text = viewModel.name.firstUppercased
//            cell.itemSubLabel.text = viewModel.subTitle?.firstUppercased
//            cell.itemExtraSubLabel.text = viewModel.extraSubTitle?.firstUppercased
//            cell.storageLabel.text = viewModel.storagePlace.firstUppercased
//            cell.storageNumberLabel.text = viewModel.storageNumber.uppercased()
//            return cell
//        case 2:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
//            cell.lentOutButton.setup(title: "Lent out", backgroundColor: Color.primary, borderColor: Color.primary)
//            return cell
//        case 3:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailButtonCell, for: indexPath) as! DetailButtonCell
//            cell.lentOutButton.setup(icon: true, iconImage: UIImage(named: "trash")!,title: "Delete item", backgroundColor: Color.red, borderColor: Color.red)
//            return cell
//        default:
//            let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.detailImageCell, for: indexPath) as! DetailImageCell
//            return cell
//        }
        
    }
    
}
