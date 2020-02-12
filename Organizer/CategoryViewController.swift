//
//  CategoryViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Firebase
import FirebaseAuth
import UIKit

class CategoryViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Color.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.masksToBounds = true
        cv.layer.cornerRadius = CornerRadius.xxLarge
        cv.layer.maskedCorners = [.layerMinXMinYCorner]
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cv
    }()

    let searchBar = UISearchBar()

    let addCategoryButton: AddButton = {
        let b = AddButton()
        return b
    }()

    var IconCellArray: [UIImage] = [UIImage(named: "icon1")!, UIImage(named: "icon2")!, UIImage(named: "icon3")!, UIImage(named: "icon4")!, UIImage(named: "icon5")!]
    var cellTitles: [String] = ["cell1", "cell2", "cell3", "cell4", "cell5"]

    var categories: [Category] = []
    var categoryItemsCount: [String] = []
    var ref: DatabaseReference!

    var users: [User]?
    var currentUser: User?

    private let refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = Color.blue
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: FontSize.xSmall),
            .foregroundColor: Color.blue!,
        ]
        r.attributedTitle = NSAttributedString(string: "Fetching data", attributes: attributes)
        return r
    }()

    // MARK: LoadView
    override func loadView() {
        super.loadView()

        addSearchBar()
        addCollectionView()
        addNavigation()

        addNewCategoryButton()

        fetchUsers()
    }

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = Color.blue

        let userUid = Auth.auth().currentUser?.uid
        guard let userId = userUid else { return }
        fetchCategoriesFromDb(userUid: userId)



//        guard let users = self.users else {
//            return
//        }
//
//
//        for user in users {
//            if user.userId == userId {
//                self.currentUser = user
//            }
//        }

        collectionView.reloadData()
    }

    // MARK: Fetch Categories form Database
    func fetchCategoriesFromDb(userUid: String) {
        ref = Database.database().reference(withPath: "users/\(userUid)/categories")

        ref.observe(.value, with: { snapshot in
            var newCategories: [Category] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let categoryItem = Category(snapshot: snapshot) {
                    newCategories.append(categoryItem)

                    let value = snapshot.value as? [String: AnyObject]
                    let items = value?["items"] as? [String: AnyObject]

                    self.categoryItemsCount.append("\(items?.count ?? 0)")
                }
            }

            self.categories = newCategories
            self.collectionView.reloadData()
        })
    }

    func fetchCategoryItemsFromDb(userUid: String) {
        ref = Database.database().reference(withPath: "users/\(userUid)/categories/")

        ref.observe(.childChanged, with: { snapshot in

            var newCategoryItemsCount: [String] = []

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    guard let value = snapshot.value as? [String: AnyObject],
                        let items = value["items"] as? [String: AnyObject] else { return }

                    newCategoryItemsCount.append(String(items.count))
                }
            }

            self.categoryItemsCount = newCategoryItemsCount
            self.collectionView.reloadData()

        })

        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

    // MARK: AddCollectionView
    private func addCollectionView() {
        view.addSubview(collectionView)
        addPullToRefresh()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: ReuseIdentifier.categoryCell)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.emptyCell)

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
        let userUid = Auth.auth().currentUser?.uid
        guard let userId = userUid else { return }
        fetchCategoriesFromDb(userUid: userId)
        fetchCategoryItemsFromDb(userUid: userId)

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: AddNewCategoryButton
    private func addNewCategoryButton() {
        view.addSubview(addCategoryButton)
        addCategoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }

    @IBAction func newCategoryButtonTapped() {
        newCategoryPopoverView().show(animated: true)
    }

    // MARK: AddSearchBar
    fileprivate func addSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.frame = CGRect(x: 0, y: 0, width: (navigationController?.view.bounds.size.width)!, height: 64)
        searchBar.backgroundColor = Color.white
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = Color.blue
        searchBar.backgroundImage = UIImage()
        view.addSubview(searchBar)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = Color.white
    }

    // MARK: AddNavigation
    private func addNavigation() {
        let barButtonLeft = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButtonLeft
        navigationController?.navigationBar.tintColor = Color.white

        //        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = Color.blue
        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = Color.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    @IBAction func leftBarButtonTapped() {
        do {
            try Auth.auth().signOut()
            let userDefault = UserDefaults.standard
            userDefault.set(false, forKey: "userSignedIn")
            userDefault.synchronize()

            let y = LoginViewController()
            y.modalPresentationStyle = .fullScreen

            present(y, animated: true, completion: nil)
        } catch let err {
            print(err)
        }
    }

    // MARK: Functions
    func pushToCategoryItemVC(title: String, cellType: String) {
        guard let currentUser = currentUser else { return }
        let controller = CategoryItemViewController(user: currentUser)
        controller.title = title
        controller.currentCategoryCellType = cellType
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchUsers()

        let test = Auth.auth().currentUser?.email
        if test != nil {
            let x = UserDefaults.standard
            x.set(test!, forKey: "lastLoggedInUser")
            x.synchronize()
        } else {
            print(test ?? "no user")
        }

        let x = UserDefaults.standard.bool(forKey: "userSignedIn")
        if !x {
            let y = LoginViewController()
            y.modalPresentationStyle = .fullScreen
            present(y, animated: true, completion: nil)
        }

        let userUid = Auth.auth().currentUser?.uid

        guard let userId = userUid else { return }
        fetchCategoriesFromDb(userUid: userId)



//        guard let users = self.users else {
//            collectionView.reloadData()
//            return
//        }




        collectionView.reloadData()
    }

    private func fetchUsers() {
        let userUid = Auth.auth().currentUser?.uid


        let userRef = Database.database().reference(withPath: "users")
        userRef.observeSingleEvent(of: .value, with: { snapshot in

            var tempUsers: [User] = []

            if snapshot.childrenCount > 0 {
                for child in snapshot.children {

                    if let snapshot = child as? DataSnapshot,
                        let users = User(snapshot: snapshot) {
                        tempUsers.append(users)
                    }
                }
            }

            guard let userId = userUid else { return }
            for user in tempUsers {
                if user.userId == userId {
                    self.currentUser = user
                }
            }

//            self.users = tempUsers

        })
    }
}

// MARK: CollectionView extensions
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.isEmpty ? 1 : categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if categories.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.emptyCell, for: indexPath) as! EmptyCell

            cell.title.text = "No categories found"
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.categoryCell, for: indexPath) as! CategoryCell

        cell.categoryLabel.text = categories[indexPath.row].catName
        cell.icon.image = UIImage(named: categories[indexPath.row].icon)

        if !categoryItemsCount.isEmpty {
            if categoryItemsCount[indexPath.row] == "1" {
                cell.catItemCountLabel.text = "\(categoryItemsCount[indexPath.row]) item"
            } else {
                cell.catItemCountLabel.text = "\(categoryItemsCount[indexPath.row]) items"
            }
        }

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

        view.setupHeaderView(titleCount: 1, firstTitle: "Choose category", secondTitle: nil, thirdTitle: nil)

        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 68)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !categories.isEmpty else {
            newCategoryPopoverView().show(animated: true)
            return
        }

        categoryItemsCount = []
        pushToCategoryItemVC(title: categories[indexPath.row].catName,
                             cellType: categories[indexPath.row].cellType)
    }
}
