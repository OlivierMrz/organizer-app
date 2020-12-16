//
//  AddCategoryView.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol AddCategroyViewDelegate {
    func selectCellTapped()
    func selectIconTapped()
    func addButtonTapped(categoryName: String, cellType: cellType, cellIcon: iconType)
}

class AddCategoryView: UIView, SelectIconDelegate, SelectCellTypeDelegate {
    
    var editCategory: Category?
    var delegate: AddCategroyViewDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let backgroundView: UIView = {
        let v = UIView()
        v.clipsToBounds = true
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let notification = NotificationCenter.default
    private let categoryNameTextField = CustomTextField()
    private let selectIconTypeButton = UIImageView()
    private let selectIcon = PopoverLabel(title: "Choose category icon")
    private let selectCellTypeButton = UIImageView()
    
    private var selectedCellType: cellType?
    private var selectedCellIcon: iconType?

    private lazy var addButton: UIButton = { return CustomButton(title: "Add Category", backgroundColor: Color.primary, borderColor: Color.primary) }()

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        addGuestures()
        
        notification.addObserver(self,
                             selector: #selector(keyboardAdjust),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notification.addObserver(self,
                             selector: #selector(keyboardAdjust),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }

    @IBAction private func selectCellTapped() {
        delegate?.selectCellTapped()
    }

    @IBAction private func selectIconTapped() {
        delegate?.selectIconTapped()
    }
    
    func didSelectCell(icon: iconType) {
        selectedCellIcon = icon
        selectIconTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectIconTypeButton.image = icon.image
        
        layoutSubviews()
    }

    func didSelectCell(type: cellType) {
        selectedCellType = type
        selectCellTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectCellTypeButton.image = type.image
        
        layoutSubviews()
    }
    
    @IBAction private func addButtonTapped() {
        var errors: [UIView] = []
        if let categoryText = categoryNameTextField.text, categoryText.isEmpty {
            errors.append(categoryNameTextField)
        }
        if selectIconTypeButton.image == UIImage(named: "placeholder") {
            errors.append(selectIconTypeButton)
        }
        if selectCellTypeButton.image == UIImage(named: "placeholder") {
            errors.append(selectCellTypeButton)
        }

        for error in errors {
            error.layer.borderColor = UIColor.red.cgColor
        }
        
        guard errors.isEmpty else { return }
        
        guard let name = categoryNameTextField.text?.lowercased() else { return }
        
        guard let icon = selectedCellIcon, let cell = selectedCellType else { return }
        
        delegate?.addButtonTapped(categoryName: name, cellType: cell, cellIcon: icon)
    }
    
    private func addView(frame: CGRect) {
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: frame.height)
        ])
        
        titleLabel.text = "Add new category"
        subTitleLabel.text = "You can give me a number or place where you will store this item. (not required)"

        let dialogViewWidth = frame.width - 64
        
        backgroundView.addSubview(dialogView)
        NSLayoutConstraint.activate([
            dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth),
            dialogView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: 0),
            dialogView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 0),
        ])

        dialogView.addSubview(titleLabel)
        dialogView.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: Margins.medium),
            titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -Margins.largeSmall),
            titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: Margins.largeSmall),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Margins.small),
            subTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
        ])

        let categoryNameLabel = PopoverLabel(title: "Category name")

        categoryNameTextField.setup(placeHolder: "Books")

        selectIconTypeButton.layer.cornerRadius = CornerRadius.xSmall
        selectIconTypeButton.layer.masksToBounds = true
        selectIconTypeButton.layer.borderWidth = BorderWidth.small
        selectIconTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectIconTypeButton.backgroundColor = Color.lightGray
        
        selectIconTypeButton.image = selectedCellIcon == nil ? UIImage(named: "placeholder") : selectedCellIcon?.image
        selectIconTypeButton.contentMode = .scaleAspectFit
        selectIconTypeButton.isUserInteractionEnabled = true
        selectIconTypeButton.translatesAutoresizingMaskIntoConstraints = false

        let selectIconTap = UITapGestureRecognizer(target: self, action: #selector(selectIconTapped))
        selectIconTypeButton.addGestureRecognizer(selectIconTap)

        let selectCellTypeLabel = PopoverLabel(title: "Choose cell type")

        selectCellTypeButton.layer.cornerRadius = CornerRadius.xSmall
        selectCellTypeButton.layer.masksToBounds = true
        selectCellTypeButton.layer.borderWidth = BorderWidth.small
        selectCellTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectCellTypeButton.backgroundColor = Color.lightGray
        selectCellTypeButton.image = selectedCellType == nil ? UIImage(named: "placeholder") : selectedCellType?.image
        selectCellTypeButton.contentMode = .scaleAspectFit
        selectCellTypeButton.isUserInteractionEnabled = true
        selectCellTypeButton.translatesAutoresizingMaskIntoConstraints = false

        let selectCellTap = UITapGestureRecognizer(target: self, action: #selector(selectCellTapped))
        selectCellTypeButton.addGestureRecognizer(selectCellTap)

        dialogView.addSubview(categoryNameLabel)
        dialogView.addSubview(categoryNameTextField)
        dialogView.addSubview(selectIcon)
        dialogView.addSubview(selectIconTypeButton)
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

            selectIconTypeButton.topAnchor.constraint(equalTo: selectIcon.bottomAnchor, constant: Margins.xSmall),
            selectIconTypeButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            selectIconTypeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            selectIconTypeButton.heightAnchor.constraint(equalToConstant: 116),

            selectCellTypeLabel.topAnchor.constraint(equalTo: selectIconTypeButton.bottomAnchor, constant: Margins.medium),
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
    
    @objc func keyboardAdjust(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + safeAreaInsets.bottom , right: 0)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        } else {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - safeAreaInsets.bottom , right: 0)
        }
    }
    
    private func editCategoryFunc() {
        guard let category = editCategory else { return }
        selectedCellType = cellType(rawValue: category.cellType)
        selectCellTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectCellTypeButton.image = UIImage(named: category.cellType)
        
        selectedCellIcon = iconType(rawValue: category.icon)
        selectIconTypeButton.layer.borderColor = Color.lightGray.cgColor
        selectIconTypeButton.image = UIImage(named: category.icon)
        
        categoryNameTextField.text = category.name.capitalized
    }
    
    private func addGuestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGuesture(sender:)))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func tapGuesture(sender: UITouch) {
//        _ = sender.view
//        self.dismiss(animated: true, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addView(frame: self.frame)
    }

    init(editCategory: Category? = nil) {
        self.editCategory = editCategory
        super.init(frame: .zero)
        setup()
        
        editCategoryFunc()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notification.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
}
