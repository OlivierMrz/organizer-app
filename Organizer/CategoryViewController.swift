//
//  CategoryViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 17/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

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

    var IconCellArray: [UIImage] = [UIImage(named: "box")!, UIImage(named: "shelf")!, UIImage(named: "boxshelf")!, UIImage(named: "borrow")!, UIImage(named: "lent")!]
    var cellTitles: [String] = ["Boxes", "Books", "Garage", "Borrowed", "Lent"]

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = Color.blue

        addSearchBar()
        addCollectionView()
        addNavigation()

        addNewCategoryButton()
    }

    // MARK: AddCollectionView
    private func addCollectionView() {
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.categoryCell)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
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
        print("New category button tapped")
        CustomPopUpView(id: 1, name: "name test", title: "title test", loc: "card.location").show(animated: true)
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
    func pushView(controller: UIViewController, title: String) {
        let controller = controller
        controller.title = title
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let test = Auth.auth().currentUser?.email
        if test != nil {
            let x = UserDefaults.standard
            x.set(test!, forKey: "lastLoggedInUser")
            x.synchronize()
            print(test!)
        } else {
            print(test ?? "no user")
        }

        let x = UserDefaults.standard.bool(forKey: "userSignedIn")
        if !x {
            let y = LoginViewController()
            y.modalPresentationStyle = .fullScreen
            present(y, animated: true, completion: nil)
        }
    }
}

// MARK: CollectionView extensions
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.categoryCell, for: indexPath) as! CategoryCollectionViewCell

        cell.categoryLabel.text = cellTitles[indexPath.row]
        cell.icon.image = IconCellArray[indexPath.row]

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

        view.setupHeaderView(titleCount: 1, firstTitle: "Shoose category", secondTitle: nil, thirdTitle: nil)

        return view
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 68)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushView(controller: CategoryItemViewController(), title: cellTitles[indexPath.row])
    }
}
