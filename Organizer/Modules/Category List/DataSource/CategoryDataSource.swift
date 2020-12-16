//
//  CategoryDataSource.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class CategoryDataSource: NSObject, UICollectionViewDataSource {
    
    var viewModel: HomeListViewModel
    
    init(_ homeListViewModel: HomeListViewModel) {
        self.viewModel = homeListViewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.categoryViewModels.isEmpty {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as? EmptyCell else {
                return UICollectionViewCell()
            }

            cell.title.text = viewModel.noCategories
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.categoryCell, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }

        let vm = viewModel.categroyViewModels(at: indexPath.row)

        cell.categoryLabel.text = vm.name.firstUppercased
        cell.icon.image = UIImage(named: vm.icon)
        cell.catItemCountLabel.text = vm.itemCount

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell, for: indexPath) as! CollectionHeaderView

        view.setupHeaderView(titleCount: 1, firstTitle: "Choose category", secondTitle: nil, thirdTitle: nil)

        return view
    }
}
