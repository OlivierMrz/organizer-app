//
//  CategoryDelegate.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class CategoryDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var vc: HomeViewController
    private var viewModel: HomeListViewModel
    
    init(vc: HomeViewController, _ homeListViewModel: HomeListViewModel) {
        self.vc = vc
        self.viewModel = homeListViewModel
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
        guard !viewModel.categoryViewModels.isEmpty else {
            let modalViewController = AddCategoryViewController()
            modalViewController.addCategoryDelegate = vc
            modalViewController.modalPresentationStyle = .overCurrentContext
            vc.present(modalViewController, animated: true, completion: nil)
            
            return
        }
        
        let vm = viewModel.categroyViewModels(at: indexPath.row)
        let controller = ItemsViewController(category: vm.category)
        controller.title = vc.title
        guard let nav = vc.navigationController else { return }
        nav.pushViewController(controller, animated: true)
    }
}
