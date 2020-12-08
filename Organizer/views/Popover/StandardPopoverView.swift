//
//  StandardPopoverView.swift
//  Organizer
//
//  Created by Olivier Miserez on 24/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class StandardPopoverView: UIView, Modal {
    private(set) var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.black
        v.alpha = 0.6
        return v
    }()

    var dialogView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.backgroundColor = Color.primaryBackground
        v.layer.cornerRadius = CornerRadius.large
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Add new Category"
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.large, weight: FontWeight.bold)
        l.textColor = Color.black
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subTitleLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        l.textColor = Color.darkGray
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping

        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let itemNameLabel = PopoverLabel()
    private let itemNameTextField = CustomTextField()

    private let itemStoragePlaceLabel = PopoverLabel()
    private let itemStoragePlaceTextField = CustomTextField()

    private let itemStorageNumberLabel = PopoverLabel()
    private let itemStorageNumberTextField = CustomTextField()

    let addButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Add item", backgroundColor: Color.primary!, borderColor: Color.primary!)
        return b
    }()

    private var userCategories: [Category] = []

    // MARK: Init()
    convenience init(category: String) {
        self.init(frame: UIScreen.main.bounds)

        addView()

//        fetchUserCategories(userUid: userUid)
    }

    convenience init() {
        self.init(frame: UIScreen.main.bounds)

        addView()

//        fetchUserCategories(userUid: userUid)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: add Views
    private func addView() {
        titleLabel.text = "Add new item"
        subTitleLabel.text = "You can give me a number or place where you will store this item. (not required)"

        let dialogViewWidth = frame.width - 64

        backgroundView.frame = frame
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))

        addSubview(backgroundView)
        addSubview(dialogView)
        NSLayoutConstraint.activate([
            dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth),
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
            dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
        ])

        dialogView.addSubview(titleLabel)
        dialogView.addSubview(subTitleLabel)
        let tapDialogView = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        dialogView.addGestureRecognizer(tapDialogView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: Margins.medium),
            titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -Margins.largeSmall),
            titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: Margins.largeSmall),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.small),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
        ])

        itemNameLabel.setup(title: "Item name")
        itemNameTextField.setup(placeHolder: "Tintin in the Congo")
        itemStoragePlaceLabel.setup(title: "Where will you store it?")
        itemStoragePlaceTextField.setup(placeHolder: "Garage")
        itemStorageNumberLabel.setup(title: "Storage number")
        itemStorageNumberTextField.setup(placeHolder: "A2")

        dialogView.addSubview(itemNameLabel)
        dialogView.addSubview(itemNameTextField)
        dialogView.addSubview(itemStoragePlaceLabel)
        dialogView.addSubview(itemStoragePlaceTextField)
        dialogView.addSubview(itemStorageNumberLabel)
        dialogView.addSubview(itemStorageNumberTextField)

        dialogView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        // MARK: NSLayoutConstraint
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: Margins.medium),
            itemNameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: Margins.xSmall),
            itemNameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemNameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 46),

            itemStoragePlaceLabel.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: Margins.medium),
            itemStoragePlaceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemStoragePlaceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            itemStoragePlaceTextField.topAnchor.constraint(equalTo: itemStoragePlaceLabel.bottomAnchor, constant: Margins.xSmall),
            itemStoragePlaceTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemStoragePlaceTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemStoragePlaceTextField.heightAnchor.constraint(equalToConstant: 46),

            itemStorageNumberLabel.topAnchor.constraint(equalTo: itemStoragePlaceTextField.bottomAnchor, constant: Margins.medium),
            itemStorageNumberLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemStorageNumberLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            itemStorageNumberTextField.topAnchor.constraint(equalTo: itemStorageNumberLabel.bottomAnchor, constant: Margins.xSmall),
            itemStorageNumberTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemStorageNumberTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemStorageNumberTextField.heightAnchor.constraint(equalToConstant: 46),

            addButton.topAnchor.constraint(equalTo: itemStorageNumberTextField.bottomAnchor, constant: Margins.medium),
            addButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalToConstant: 46),

            addButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -Margins.medium),
        ])
    }

    // MARK: Add Button Tapped
    @IBAction private func addButtonTapped() {
        [itemNameTextField, itemStoragePlaceTextField, itemStorageNumberTextField].forEach {
            $0.layer.borderColor = Color.lightGray?.cgColor
        }

        var errors: [UIView] = []
        if let itemName = itemNameTextField.text, itemName.isEmpty {
            errors.append(itemNameTextField)
        }
        if let storagePlace = itemStoragePlaceTextField.text, storagePlace.isEmpty {
            errors.append(itemStoragePlaceTextField)
        }
        if let storageNumber = itemStorageNumberTextField.text, storageNumber.isEmpty {
            errors.append(itemStorageNumberTextField)
        }

        for error in errors {
            error.layer.borderColor = UIColor.red.cgColor
        }

//        guard errors.isEmpty, let ref = ref else { return }
//
//        guard let itemName = itemNameTextField.text,
//            let storagePlace = itemStoragePlaceTextField.text,
//            let storageNumber = itemStorageNumberTextField.text else { return }
//
//        let newItem = CategoryItem(itemName: itemName, itemSubTitle: "", extraSubTitle: "", storagePlace: storagePlace, storageNumber: storageNumber, borrowed: false, borrowedBy: "", imageData: nil)
//
//        let uuid = UUID().uuidString
//        let ItemRef = ref.child(uuid)
//
//        ItemRef.setValue(newItem.toAnyObject())

        dismiss(animated: true)
    }

    // MARK: check If New Category name Exists
    private func checkIfNewCategoryExists(catName: String) -> Bool {
        for cat in userCategories {
            if cat.catName == catName {
                return true
            }
        }
        return false
    }

    // MARK: fetch User Categories
    private func fetchUserCategories(userUid: String) {
//        let transactionRef = Database.database().reference(withPath: "users/\(userUid)/categories")
//
//        transactionRef.observeSingleEvent(of: .value, with: { snapshot in
//
//            var userCategories: [Category] = []
//
//            if snapshot.childrenCount > 0 {
//                for child in snapshot.children {
//                    if let snapshot = child as? DataSnapshot,
//                        let categoryItem = Category(snapshot: snapshot) {
//                        userCategories.append(categoryItem)
//                    }
//                }
//            }
//
//            self.userCategories = userCategories
//
//        })
    }

    // MARK: IBAction buttons
    @IBAction private func viewTapped() {
        dialogView.endEditing(true)
    }

    @objc private func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }

    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}
