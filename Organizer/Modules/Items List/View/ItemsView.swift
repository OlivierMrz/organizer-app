//
//  ItemsView.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol ItemsViewDelegate {
    func addNewItemTapped()
}

class ItemsView: UIView {
    
    var delegate: ItemsViewDelegate?

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

    private lazy var searchBar = UISearchBar()
    private lazy var addCategoryButton: UIButton = { return AddButton() }()
    private lazy var refreshControl: UIRefreshControl = { return CustomRefreshControl(frame: .zero) }()
    
    private func addCollectionView() {
        addSubview(collectionView)
        addPullToRefresh()

        collectionView.isScrollEnabled = true
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)
        collectionView.register(DetailedCell.self, forCellWithReuseIdentifier: ReuseIdentifier.detailedCell)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.emptyCell)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: ReuseIdentifier.titleCell)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }
    
    private func addSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = Color.primaryBackground
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = Color.primary
        searchBar.backgroundImage = UIImage()
        addSubview(searchBar)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = Color.primaryBackground
    }
    
    private func addNewItemButton() {
        addSubview(addCategoryButton)
        addCategoryButton.addTarget(self, action: #selector(newItemButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            addCategoryButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
    
    @IBAction private func newItemButtonTapped() {
        delegate?.addNewItemTapped()
    }

    private func addPullToRefresh() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    private func setup() {
        backgroundColor = Color.primary
        addSearchBar()
        addCollectionView()
        
        addNewItemButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 64)
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
