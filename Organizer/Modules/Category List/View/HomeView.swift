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
    func editExistingCategory(vm: CategoryViewModel)
}

class HomeView: UIView, UIGestureRecognizerDelegate {
    
    var delegate: HomeViewDelegate?
    var devDelegate: DevModeDelegate?
    var viewModel: HomeListViewModel

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

    private let devModeView: DevModeView = {
        let v = DevModeView()
        v.backgroundColor = .gray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var devModeButton: UIButton = {
        return CustomButton(title: "DEV", backgroundColor: .systemRed, borderColor: .systemRed)
    }()
    private var isDevModeViewVisible = false
    private var devModeViewLeadingContraint: NSLayoutConstraint?
    
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
    
    private enum devModeViewType {
        case visible, notVisible
        
        var value: CGFloat {
            switch self {
            case .visible:
                return 0
            case .notVisible:
                return -300
            }
        }
    }
    
    private func addDevModeView(bounds: CGRect) {
        addSubview(devModeView)
        NSLayoutConstraint.activate([
            devModeViewLeadingContraint!,
            devModeView.widthAnchor.constraint(equalToConstant: 300),
            devModeView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            devModeView.heightAnchor.constraint(equalToConstant: bounds.height)
        ])
        
        addSubview(devModeButton)
        devModeButton.addTarget(self, action: #selector(devModeButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            devModeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            devModeButton.widthAnchor.constraint(equalToConstant: 60),
            devModeButton.heightAnchor.constraint(equalToConstant: 40),
            devModeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        devModeView.delegate = devDelegate
    }
    
    @objc private func devModeButtonTapped() {
        
        if !isDevModeViewVisible {
            devModeViewLeadingContraint?.constant = devModeViewType.visible.value
            isDevModeViewVisible = true
        } else {
            devModeViewLeadingContraint?.constant = devModeViewType.notVisible.value
            isDevModeViewVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
            self.layoutIfNeeded()
        }

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
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.4
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let p = gestureRecognizer.location(in: collectionView)

            if let indexPath = collectionView.indexPathForItem(at: p) {
                if let _ = collectionView.cellForItem(at: indexPath) as? EmptyCell {
                    return
                }
                
                delegate?.editExistingCategory(vm: viewModel.categroyViewModels(at: indexPath.row))
            }
        default:
            return
        }
    }
    
    private func setup() {
        backgroundColor = viewModel.viewBackgroundColor
        
        addSearchBar()
        addCollectionView()
        addNewCategoryButton()
        
        setupLongGestureRecognizerOnCollection()
//        addDevModeView(bounds: self.bounds)
        devModeViewLeadingContraint = devModeView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: devModeViewType.notVisible.value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 64)
        
        addDevModeView(bounds: self.bounds)
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
