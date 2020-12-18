//
//  ItemsDelegate.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class ItemsDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: ItemListViewModel
    private var mainVc: ItemsViewController
    
    init(vc: ItemsViewController, viewModel: ItemListViewModel) {
        self.mainVc = vc
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minLineSpacingCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minInteritemSpacingCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.headerSize(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.itemViewModels.isEmpty else {
            mainVc.addNewItemTapped()
            return
        }
        let vm = viewModel.itemViewModels(at: indexPath.row)

        mainVc.coordinator?.goToItemDetail(vm: vm)
        
//        let vc = ItemDetailViewController(itemViewModel: vm)
//        vc.title = vm.name.capitalized
//        mainVc.navigationController?.pushViewController(vc, animated: true)
    }
}
