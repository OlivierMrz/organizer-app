//
//  HomeViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AddCategoryDelegate, HomeViewDelegate, DevModeDelegate {

    // MARK: - Properties
    var coordinator: MainCoordinator?
    private var mainView: HomeView?
    var viewModel = HomeListViewModel()
    private var dataSource: CategoryDataSource!
    private var delegate: CategoryDelegate!
    
    // MARK: - Lifecycle 🧬
    
    override func loadView() {
        super.loadView()
        mainView = HomeView(viewModel: viewModel)
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel = HomeListViewModel()
        self.mainView?.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = CategoryDataSource(viewModel)
        self.delegate = CategoryDelegate(vc: self, viewModel)
        
        mainView?.delegate = self
        mainView?.devDelegate = self
        mainView?.collectionView.delegate = delegate
        mainView?.collectionView.dataSource = dataSource
        
        title = viewModel.title
        addNavigation()
    }
    
    // MARK: - Delegate Methods
    
    func devGoToItemDetail() {
        print("-- DEV item detail tapped received on Controller")
        coordinator?.goToItemDetail()
    }
    
    func addCategoryDidSave(vm: CategoryViewModel?) {
        if let vm = vm {
            self.viewModel.addCategoryViewModel(vm)
        }
        
        updateCollectionView()
    }
    
    private func updateCollectionView() {
        mainView?.viewModel = viewModel
        dataSource.viewModel = viewModel
        delegate.viewModel = viewModel
        DispatchQueue.main.async {
            self.mainView?.collectionView.reloadData()
        }
    }
    
    func editExistingCategory(vm: CategoryViewModel) {
        CoreDataManager.shared.getItemWith(name: vm.name) { (result) in
            let modalViewController = AddCategoryViewController(category: result)
            modalViewController.addCategoryDelegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - View Button actions
    func newCategoryButtonTapped() {
        let modalViewController = AddCategoryViewController()
        modalViewController.addCategoryDelegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        
        coordinator?.presentAddCategoryVc(modalViewController)
    }
    

    // MARK: - UI
    private func addNavigation() {
        let leftButton = UIBarButtonItem(image: UIImage.init(systemName: "trash"), style: .plain, target: self, action: #selector(trashButtonTapped))
        navigationItem.leftBarButtonItem = leftButton
        navigationController?.navigationBar.tintColor = Color.primaryBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = Color.primaryBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func trashButtonTapped() {
        self.presentAlert(type: .warning) {
            CoreDataManager.shared.deleteAllDBData()
            self.viewModel.fetchCategories()
            self.updateCollectionView()
        }
    }
}
