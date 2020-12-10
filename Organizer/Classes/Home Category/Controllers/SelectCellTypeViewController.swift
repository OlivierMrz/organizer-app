//
//  SelectCellTypeViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 21/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol SelectCellTypeDelegate: AnyObject {
    func didSelectCell(type: cellType)
}

class SelectCellTypeViewController: UIViewController {
    
    var viewModel = SelectCellListViewModel()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = Color.darkGray
        l.text = "Choose the type of cell"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

//    private var cellTypeArray: [UIImage] = [
//        UIImage(named: "cell2")!,
//        UIImage(named: "cell3")!
//    ]

    weak var delegate: SelectCellTypeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.primaryBackground
        addTitleLabel()
        addCollectionView()
    }
    
    func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SelectIconCell.self, forCellWithReuseIdentifier: ReuseIdentifier.selectIconCell)
        collectionView.contentInset = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }

    private func addTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }
}

extension SelectCellTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectIconCell, for: indexPath) as? SelectIconCell else {
            return UICollectionViewCell()
        }
        
        let vm = viewModel.selectCellViewModel(at: indexPath.row)
        cell.imageView.contentMode = .center
        cell.imageView.image = vm.image

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectIconCell {
            cellType.allCases.forEach { (result) in
                if result.image == cell.imageView.image {
                    delegate?.didSelectCell(type: result)
                }
            }
        }
        dismiss(animated: true, completion: nil)
//        delegate?.didSelectCell(type: indexPath.row)
//        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
