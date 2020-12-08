//
//  newCategoryPopoverView.swift
//  CustomPopUpController
//
//  Created by Olivier Miserez on 20/01/2019.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class newCategoryPopoverView: UIView, Modal, SelectIconDelegate, SelectCellTypeDelegate {
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

    private let categoryNameTextField = CustomTextField()
    private let selectIconButton = UIImageView()
    private let selectIcon = PopoverLabel()
    private let selectCellTypeButton = UIImageView()

    let addButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Add Category", backgroundColor: Color.primary!, borderColor: Color.primary!)
        return b
    }()

    private var imageArray: [String] = ["icon1", "icon2", "icon3", "icon4", "icon5"]

    private var cellTypeArray: [UIImage] = [
        UIImage(named: "cell2")!,
        UIImage(named: "cell3")!,
    ]
    private var userCategories: [Category] = []

    private var selectedCellType: Int = 0
    private var selectedCellIcon: Int = 0

    // MARK: Init()
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

    // MARK: DidSelectCell ICON
    internal func didSelectCell(icon: Int) {
        selectedCellIcon = (icon + 1)
        selectIconButton.layer.borderColor = Color.lightGray?.cgColor
        selectIconButton.image = UIImage(named: imageArray[icon])
    }

    // MARK: DidSelectCell TYPE
    internal func didSelectCell(type: Int) {
        selectedCellType = (type + 1)
        selectCellTypeButton.layer.borderColor = Color.lightGray?.cgColor
        selectCellTypeButton.image = cellTypeArray[type]
    }

    // MARK: addView
    private func addView() {
        titleLabel.text = "Add new category"
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

        let categoryNameLabel = PopoverLabel()
        categoryNameLabel.setup(title: "Category name")

        categoryNameTextField.setup(placeHolder: "Books")

        selectIcon.setup(title: "Choose category icon")

        selectIconButton.layer.cornerRadius = CornerRadius.xSmall
        selectIconButton.layer.masksToBounds = true
        selectIconButton.layer.borderWidth = BorderWidth.small
        selectIconButton.layer.borderColor = Color.lightGray?.cgColor
        selectIconButton.backgroundColor = Color.lightGray
        selectIconButton.image = UIImage(named: "placeholder")
        selectIconButton.contentMode = .scaleAspectFit
        selectIconButton.isUserInteractionEnabled = true
        selectIconButton.translatesAutoresizingMaskIntoConstraints = false

        let selectIconTap = UITapGestureRecognizer(target: self, action: #selector(selectIconTapped))
        selectIconButton.addGestureRecognizer(selectIconTap)

        let selectCellTypeLabel = PopoverLabel()
        selectCellTypeLabel.setup(title: "Choose cell type")

        selectCellTypeButton.layer.cornerRadius = CornerRadius.xSmall
        selectCellTypeButton.layer.masksToBounds = true
        selectCellTypeButton.layer.borderWidth = BorderWidth.small
        selectCellTypeButton.layer.borderColor = Color.lightGray?.cgColor
        selectCellTypeButton.backgroundColor = Color.lightGray
        selectCellTypeButton.image = UIImage(named: "placeholder")
        selectCellTypeButton.contentMode = .scaleAspectFit
        selectCellTypeButton.isUserInteractionEnabled = true
        selectCellTypeButton.translatesAutoresizingMaskIntoConstraints = false

        let selectCellTap = UITapGestureRecognizer(target: self, action: #selector(selectCellTapped))
        selectCellTypeButton.addGestureRecognizer(selectCellTap)

        dialogView.addSubview(categoryNameLabel)
        dialogView.addSubview(categoryNameTextField)
        dialogView.addSubview(selectIcon)
        dialogView.addSubview(selectIconButton)
        dialogView.addSubview(selectCellTypeLabel)
        dialogView.addSubview(selectCellTypeButton)
        dialogView.addSubview(addButton)

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        // MARK: NSLayoutConstraint
        NSLayoutConstraint.activate([
            categoryNameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: Margins.medium),
            categoryNameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            categoryNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: Margins.xSmall),
            categoryNameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            categoryNameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 46),

            selectIcon.topAnchor.constraint(equalTo: categoryNameTextField.bottomAnchor, constant: Margins.medium),
            selectIcon.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            selectIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            selectIconButton.topAnchor.constraint(equalTo: selectIcon.bottomAnchor, constant: Margins.xSmall),
            selectIconButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            selectIconButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            selectIconButton.heightAnchor.constraint(equalToConstant: 116),

            selectCellTypeLabel.topAnchor.constraint(equalTo: selectIconButton.bottomAnchor, constant: Margins.medium),
            selectCellTypeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            selectCellTypeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            selectCellTypeButton.topAnchor.constraint(equalTo: selectCellTypeLabel.bottomAnchor, constant: Margins.xSmall),
            selectCellTypeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            selectCellTypeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            selectCellTypeButton.heightAnchor.constraint(equalToConstant: 66),

            addButton.topAnchor.constraint(equalTo: selectCellTypeButton.bottomAnchor, constant: Margins.medium),
            addButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalToConstant: 46),

            addButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -Margins.medium),
        ])
    }

    // MARK: Add Button Tapped
    @IBAction private func addButtonTapped() {
        var errors: [UIView] = []
        if let categoryText = categoryNameTextField.text, categoryText.isEmpty {
            errors.append(categoryNameTextField)
        }
        if selectIconButton.image == UIImage(named: "placeholder") {
            errors.append(selectIconButton)
        }
        if selectCellTypeButton.image == UIImage(named: "placeholder") {
            errors.append(selectCellTypeButton)
        }

        for error in errors {
            error.layer.borderColor = UIColor.red.cgColor
        }

        guard errors.isEmpty else { return }

        let catName = categoryNameTextField.text!.lowercased()

        let x = checkIfNewCategoryExists(catName: catName)

//        if !x {
//            let newCategory = Category(catName: catName,
//                                       icon: "icon\(selectedCellIcon)",
//                                       cellType: "cell\(selectedCellType)")
//
//            let ItemRef = ref.child(catName)
//
//            ItemRef.setValue(newCategory.toAnyObject())
//            let currentVc = CategoryViewController()
//            currentVc.collectionView.reloadData()
//            dismiss(animated: true)
//        } else {
//            let alert = UIAlertController(title: "⚠️ ALERT!", message: "Category name already in use.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//            let vc = getCurrentViewController()
//            vc?.present(alert, animated: true, completion: nil)
//
//            categoryNameTextField.layer.borderColor = UIColor.red.cgColor
//        }
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

    @IBAction private func selectCellTapped() {
        let vc = SelectCellTypeViewController()
        let currentController = getCurrentViewController()
        vc.delegate = self
        currentController?.present(vc, animated: true, completion: nil)
    }

    @IBAction private func selectIconTapped() {
        let vc = SelectIconViewController()
        let currentController = getCurrentViewController()
        vc.delegate = self
        currentController?.present(vc, animated: true, completion: nil)
    }

    @objc private func didTappedOnBackgroundView() {
        dismiss(animated: true)
    }

    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}