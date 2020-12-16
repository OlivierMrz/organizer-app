//
//  ItemsDataSource.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class ItemsDataSource: NSObject, UICollectionViewDataSource {
    
    private let viewModel: ItemListViewModel
    
    init(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.itemViewModels.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as! EmptyCell
            cell.title.text = "No items yet"

            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.detailedCell, for: indexPath) as? DetailedCell else {
            return UICollectionViewCell()
        }
        
        let vm = viewModel.itemViewModels(at: indexPath.row)

        cell.itemLabel.text = vm.name.firstUppercased
        cell.itemSubLabel.text = vm.subTitle?.firstUppercased
        cell.itemSub2Label.text = vm.extraSubTitle?.firstUppercased
        cell.placeLabel.text = vm.storagePlace.capitalized
        cell.placeStorageLabel.text = vm.storageNumber.uppercased()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell, for: indexPath) as! CollectionHeaderView

        view.setupHeaderView(titleCount: 2, firstTitle: "Item", secondTitle: "place", thirdTitle: nil)

        return view
    }

}
