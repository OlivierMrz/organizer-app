//
//  ItemsViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, AddItemDelegate {

    var viewModel: ItemListViewModel
    
    init(category: Category) {
        viewModel = ItemListViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Color.primaryBackground
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.masksToBounds = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cv
    }()

    private lazy var addCategoryButton: UIButton = { return AddButton() }()
    private let searchBar = UISearchBar()

    private var categoryItems: [Item] = []

    var currentCategoryCellType: String = ""

    private let refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = Color.primary
        r.backgroundColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: FontSize.xSmall),
            .foregroundColor: Color.primary!,
        ]
        r.attributedTitle = NSAttributedString(string: "Fetching data", attributes: attributes)
        return r
    }()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCategoryItemsFromDb()

        view.backgroundColor = Color.primary

        addSearchBar()
        addCollectionView()
        addNavigation()
        addNewItemButton()
    }

    // MARK: Fetch Categories form Database
    private func fetchCategoryItemsFromDb() {
//        let userEmail = (Auth.auth().currentUser?.uid)!
//        let currentCategory = title!
//        ref = Database.database().reference(withPath: "users/\(userEmail)/categories/\(currentCategory)/items")
//
//        ref.observe(.value, with: { snapshot in
//            var tempCategoryItems: [CategoryItem] = []
//
//            for child in snapshot.children {
//                if let snapshot = child as? DataSnapshot,
//                    let categoryItem = CategoryItem(snapshot: snapshot) {
//                    tempCategoryItems.append(categoryItem)
//                }
//            }
//
//            self.categoryItems = tempCategoryItems
//            self.collectionView.reloadData()
//        })
//
//        DispatchQueue.main.async {
//            self.refreshControl.endRefreshing()
//        }
    }

    // MARK: Delegate's
    func addItemDidSave(vm: itemViewModel) {
        self.viewModel.addItemViewModel(vm)
        self.collectionView.reloadData()
    }
    
    // MARK: AddNewCategoryButton
    private func addNewItemButton() {
        view.addSubview(addCategoryButton)
        addCategoryButton.addTarget(self, action: #selector(newItemButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    @IBAction private func newItemButtonTapped() {
        checkCellType()
//        DetailedPopoverView(category: title!).show(animated: true)
    }

    // MARK: AddCollectionView
    private func addCollectionView() {
        view.addSubview(collectionView)
        addPullToRefresh()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)
        collectionView.register(DetailedCell.self, forCellWithReuseIdentifier: ReuseIdentifier.detailedCell)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.emptyCell)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: ReuseIdentifier.titleCell)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }

    private func addPullToRefresh() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: Any) {
        fetchCategoryItemsFromDb()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: AddSearchBar
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

    // MARK: AddNavigation
    private func addNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = Color.primaryBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    // MARK: Check Cell Type and show
    private func checkCellType() {
        switch viewModel.categoryCellType {
        case .basic:
            let modalViewController = StandardPopOverViewController(category: viewModel.category)
            modalViewController.addItemDelegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
            
        case .subtitlePlus:
            let modalViewController = DetailedPopOverViewController(category: viewModel.category)
            modalViewController.addItemDelegate = self
            modalViewController.modalPresentationStyle = .overCurrentContext
            present(modalViewController, animated: true, completion: nil)
        }
    }
}

// MARK: CollectionView extensions
extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemViewModels.isEmpty ? 1 : viewModel.itemViewModels.count
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
        return CGSize(width: collectionView.frame.width - Margins.collectionCellMargin, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
        return CGSize(width: collectionView.frame.width, height: 68)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.itemViewModels.isEmpty else {
            checkCellType()
            return
        }
        let vm = viewModel.itemViewModels(at: indexPath.row)

        let vc = ItemDetailViewController(itemViewModel: vm)
        vc.title = vm.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
