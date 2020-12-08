//
//  CategoryItemViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CategoryItemViewController: UIViewController {
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

    private let addCategoryButton: AddButton = {
        let b = AddButton()
        return b
    }()

    private let searchBar = UISearchBar()

    private var categoryItems: [CategoryItem] = []

    var currentCategoryCellType: String = ""
    private var currentUser: User?

    private let refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = Color.primary
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: FontSize.xSmall),
            .foregroundColor: Color.primary!,
        ]
        r.attributedTitle = NSAttributedString(string: "Fetching data", attributes: attributes)
        return r
    }()

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.currentUser = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }

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
        //        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = Color.primary
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = Color.primaryBackground
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    // MARK: Check Cell Type and show
    private func checkCellType() {
        switch currentCategoryCellType {
        case "cell1": // Standard PopoverView
            StandardPopoverView(category: title!).show(animated: true)
        case "cell2":   // Detailed PopoverView
            DetailedPopoverView(category: title!).show(animated: true)
        default:
            StandardPopoverView(category: title!).show(animated: true)
        }
    }
}

// MARK: CollectionView extensions
extension CategoryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.isEmpty ? 1 : categoryItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if categoryItems.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as! EmptyCell
            cell.title.text = "No items yes"

            return cell
        }

        switch currentCategoryCellType {
        case "cell1": // TitleCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.titleCell, for: indexPath) as! TitleCell

            cell.title.text = categoryItems[indexPath.row].itemName
            cell.storagePlaceLabel.text = categoryItems[indexPath.row].storagePlace
            cell.storageNumberLabel.text = categoryItems[indexPath.row].storageNumber
            return cell
        case "cell2": // DetailedCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.detailedCell, for: indexPath) as! DetailedCell

            cell.itemLabel.text = categoryItems[indexPath.row].itemName
            cell.itemSubLabel.text = categoryItems[indexPath.row].itemSubTitle
            cell.itemSub2Label.text = categoryItems[indexPath.row].extraSubTitle
            cell.placeLabel.text = categoryItems[indexPath.row].storagePlace
            cell.placeStorageLabel.text = categoryItems[indexPath.row].storageNumber

            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as! EmptyCell

            cell.title.text = "No items found"
            return cell
        }
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
        guard !categoryItems.isEmpty else {
            checkCellType()
            return
        }

        let vc = ItemDetailViewController()
        vc.detailItem = categoryItems[indexPath.row]
        vc.title = categoryItems[indexPath.row].itemName
        navigationController?.pushViewController(vc, animated: true)
    }
}