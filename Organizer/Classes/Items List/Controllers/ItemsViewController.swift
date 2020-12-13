//
//  ItemsViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, AddItemDelegate, ItemsViewDelegate {
    
    private let mainView = ItemsView()
    private var viewModel: ItemListViewModel
    
    override func loadView() {
        super.loadView()
        mainView.delegate = self
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        addNavigation()
    }

    // MARK: Delegate's
    func addItemDidSave(vm: ItemViewModel) {
        self.viewModel.addItemViewModel(vm)
        mainView.collectionView.reloadData()
    }
    
    func addNewItemTapped() {
        let modalViewController = AddItemViewController(cellType: viewModel.categoryCellType, category: viewModel.category)
        modalViewController.addItemDelegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        
        present(modalViewController, animated: true, completion: nil)
    }

    // MARK: AddNavigation
    private func addNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = Color.primaryBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    init(category: Category) {
        viewModel = ItemListViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: CollectionView extensions
extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.itemViewModels.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as! EmptyCell
            cell.title.text = "No items yes"

            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.detailedCell, for: indexPath) as? DetailedCell else {
            return UICollectionViewCell()
        }
        
        let vm = viewModel.itemViewModels(at: indexPath.row)

        cell.itemLabel.text = vm.name
        cell.itemSubLabel.text = vm.subTitle
        cell.itemSub2Label.text = vm.extraSubTitle
        cell.placeLabel.text = vm.storagePlace
        cell.placeStorageLabel.text = vm.storageNumber

        return cell
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell, for: indexPath) as! CollectionHeaderView

        view.setupHeaderView(titleCount: 2, firstTitle: "Item", secondTitle: "place", thirdTitle: nil)

        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.headerSize(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.itemViewModels.isEmpty else {
            addNewItemTapped()
            return
        }
        let vm = viewModel.itemViewModels(at: indexPath.row)

        let vc = ItemDetailViewController(itemViewModel: vm)
        vc.title = vm.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
