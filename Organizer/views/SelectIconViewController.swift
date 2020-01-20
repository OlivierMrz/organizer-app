//
//  SelectIconViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 20/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol SelectIconDelegate: AnyObject {
    func didSelectCell(icon: Int)
}

class SelectIconViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    var imageArray: [UIImage] = [
        UIImage(named: "box")!,
        UIImage(named: "shelf")!,
        UIImage(named: "boxshelf")!,
        UIImage(named: "borrow")!,
        UIImage(named: "lent")!,
    ]

    weak var delegate: SelectIconDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white

        addCollectionView()
    }

    @IBAction func leftBarButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SelectIconCell.self, forCellWithReuseIdentifier: ReuseIdentifier.selectIconCell)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }
}

extension SelectIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.selectIconCell, for: indexPath) as! SelectIconCell
        cell.backgroundColor = Color.lightGray

        cell.imageView.image = imageArray[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCell(icon: indexPath.row)
        dismiss(animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
