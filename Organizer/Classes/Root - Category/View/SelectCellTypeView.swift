//
//  SelectCellTypeView.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class SelectCellTypeView: UIView {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.text = "Choose the type of cell"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func addCollectionView() {
        addSubview(collectionView)
        collectionView.register(SelectIconCell.self, forCellWithReuseIdentifier: ReuseIdentifier.selectIconCell)
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }

    private func addTitleLabel() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }
    
    private func setup() {
        backgroundColor = Color.primaryBackground
        addTitleLabel()
        addCollectionView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
