//
//  HomeViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, AddCategoryDelegate {
    
    // MARK: - Properties
    var viewModel = HomeListViewModel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Color.primaryBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = CornerRadius.xxLarge
        cv.layer.maskedCorners = [.layerMinXMinYCorner]
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cv
    }()

    private let searchBar = UISearchBar()
    private lazy var addCategoryButton: UIButton = { return AddButton() }()
    private let refreshControl: UIRefreshControl = { return CustomRefreshControl(frame: .zero) }()
    
    // MARK: - Lifecycle 🧬
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = viewModel.viewBackgroundColor
        
        addSearchBar()
        addCollectionView()
        addNavigation()
        addNewCategoryButton()

        collectionView.reloadData()
    }
    
    func addCategoryDidSave(vm: CategoryViewModel) {
        self.viewModel.addCategoryViewModel(vm)
        self.collectionView.reloadData()
    }
    
    // MARK: - Button actions
    
    @objc private func refreshData() {
        viewModel.fetchCategories()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    @objc func newCategoryButtonTapped() {
        let modalViewController = CategoryPopOverViewController()
        modalViewController.addCategoryDelegate = self
        modalViewController.modalPresentationStyle = .overCurrentContext
        present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func trashButtonTapped() {
        CoreDataManager.shared.deleteAllDBData()
        self.viewModel.fetchCategories()
        self.collectionView.reloadData()
    }

    // MARK: - UI
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        addPullToRefresh()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = viewModel.canScroll

        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: ReuseIdentifier.categoryCell)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.emptyCell)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Margins.medium),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Margins.zero),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Margins.zero),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Margins.zero),
        ])
    }

    private func addPullToRefresh() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func addNewCategoryButton() {
        view.addSubview(addCategoryButton)
        addCategoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Margins.addButton),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Margins.addButton),
        ])
    }

    private func addSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.frame = CGRect(x: 0, y: 0, width: (navigationController?.view.bounds.size.width)!, height: 64)
        searchBar.backgroundColor = Color.primaryBackground
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = Color.primary
        searchBar.backgroundImage = UIImage()
        view.addSubview(searchBar)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = Color.primaryBackground
    }

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
            let modalViewController = CategoryPopOverViewController()
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
