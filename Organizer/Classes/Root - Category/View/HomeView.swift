//
//  HomeView.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol HomeViewDelegate {
    func newCategoryButtonTapped()
}

class HomeView: UIView {
    
    var delegate: HomeViewDelegate?

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
    
    private func addCollectionView() {
        addSubview(collectionView)
        addPullToRefresh()

        collectionView.isScrollEnabled = viewModel.canScroll

        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: ReuseIdentifier.categoryCell)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReuseIdentifier.headerCell)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: ReuseIdentifier.emptyCell)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Margins.medium),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Margins.zero),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Margins.zero),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.zero),
        ])
    }

    private func addPullToRefresh() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func addNewCategoryButton() {
        addSubview(addCategoryButton)
        addCategoryButton.addTarget(self, action: #selector(newCategoryButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.addButton),
            addCategoryButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Margins.addButton),
        ])
    }

    private func addSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.frame = .zero
        searchBar.backgroundColor = Color.primaryBackground
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        searchBar.barTintColor = Color.primary
        searchBar.backgroundImage = UIImage()
        addSubview(searchBar)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = Color.primaryBackground
    }
    
    @objc private func refreshData() {
        viewModel.fetchCategories()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    @objc func newCategoryButtonTapped() {
        delegate?.newCategoryButtonTapped()
    }
    
    private var viewModel: HomeListViewModel
    
    private func setup() {
        backgroundColor = viewModel.viewBackgroundColor
        
        addSearchBar()
        addCollectionView()
        addNewCategoryButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 64)
    }
    
    init(viewModel: HomeListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
