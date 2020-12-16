//
//  SelectIconViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol SelectIconDelegate: AnyObject {
    func didSelectCell(icon: iconType)
}

class SelectIconViewController: UIViewController {
    
    // MARK: - Properties
    private var mainView = SelectIconView()
    var viewModel = SelectIconListViewModel()
    weak var delegate: SelectIconDelegate?
    
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

extension SelectIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectIconViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectIconCell, for: indexPath) as? SelectIconCell else {
            return UICollectionViewCell()
        }
        
        let vm = viewModel.selectIconViewModel(at: indexPath.row)
        cell.backgroundColor = Color.lightGray
        cell.imageView.image = vm.icon

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectIconCell {
            iconType.allCases.forEach { (result) in
                if result.image == cell.imageView.image {
                    delegate?.didSelectCell(icon: result)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
