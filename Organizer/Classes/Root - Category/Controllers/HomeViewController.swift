//
//  HomeViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AddCategoryDelegate, HomeViewDelegate {
        
    // MARK: - Properties
    private var mainView: HomeView?
    var viewModel = HomeListViewModel()
    
    // MARK: - Lifecycle 🧬
    
    override func loadView() {
        super.loadView()
        mainView = HomeView(viewModel: viewModel)
        view = mainView
        mainView?.delegate = self
        mainView?.collectionView.delegate = self
        mainView?.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel = HomeListViewModel()
        self.mainView?.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        addNavigation()
    }
    
    func addCategoryDidSave(vm: CategoryViewModel) {
        self.viewModel.addCategoryViewModel(vm)
        self.mainView?.collectionView.reloadData()
    }
    
    // MARK: - View Button actions
    func newCategoryButtonTapped() {
        let modalViewController = AddCategoryViewController()
        modalViewController.addCategoryDelegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
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
            self.mainView?.collectionView.reloadData()
        }
    }
}

// MARK: CollectionViewDelegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

        cell.categoryLabel.text = vm.name
        cell.icon.image = UIImage(named: vm.icon)
        cell.catItemCountLabel.text = vm.itemCount

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

        view.setupHeaderView(titleCount: 1, firstTitle: "Choose category", secondTitle: nil, thirdTitle: nil)

        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.headerSize(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.categoryViewModels.isEmpty else {
            let modalViewController = AddCategoryViewController()
            modalViewController.addCategoryDelegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
            
            return
        }
        
        let vm = viewModel.categroyViewModels(at: indexPath.row)
        let controller = ItemsViewController(category: vm.category)
        controller.title = title
        guard let nav = navigationController else { return }
        nav.pushViewController(controller, animated: true)
        
        
//        pushToCategoryItemVC(category: vm.category,
//                            title: vm.name,
//                            cellType: vm.type)
    }
}
