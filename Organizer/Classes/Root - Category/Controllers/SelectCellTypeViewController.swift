//
//  SelectCellTypeViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 21/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol SelectCellTypeDelegate: AnyObject {
    func didSelectCell(type: cellType)
}

class SelectCellTypeViewController: UIViewController {
    
    private let mainView = SelectCellTypeView()
    var viewModel = SelectCellListViewModel()
    weak var delegate: SelectCellTypeDelegate?
    
    override func loadView() {
        super.loadView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}

extension SelectCellTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectIconCell, for: indexPath) as? SelectIconCell else {
            return UICollectionViewCell()
        }
        
        let vm = viewModel.selectCellViewModel(at: indexPath.row)
        cell.imageView.contentMode = .center
        cell.imageView.image = vm.image

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectIconCell {
            cellType.allCases.forEach { (result) in
                if result.image == cell.imageView.image {
                    delegate?.didSelectCell(type: result)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
