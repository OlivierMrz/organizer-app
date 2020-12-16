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
    private var dataSource: ItemsDataSource
    private var delegate: ItemsDelegate?
    
    override func loadView() {
        super.loadView()
        mainView.delegate = self
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = delegate
        mainView.collectionView.dataSource = dataSource
        
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
        dataSource = ItemsDataSource(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        delegate = ItemsDelegate(vc: self, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
