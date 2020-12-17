//
//  AddItemView.swift
//  Organizer
//
//  Created by Olivier Miserez on 13/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol addItemViewDelegate {
    func addImageButtonTapped()
    func addItemButtonTapped(itemName: String, storagePlace: String, storageNumber: String, itemSub: String?, itemExtraSub: String?)
    func backgroundViewTapped()
}

class AddItemView: UIView, UIGestureRecognizerDelegate {
    
    var delegate: addItemViewDelegate?

    private var cellType: cellType
    private var currentCategory: Category
    private var notification = NotificationCenter.default
    
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
        l.text = "Add new Item"
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

    private let itemNameLabel = PopoverLabel(title: "Item name")
    private let itemNameTextField = CustomTextField()
    
    private let itemSubTextField = CustomTextField()
    
    private let itemExtraSubTextField = CustomTextField()

    private let itemStoragePlaceLabel = PopoverLabel(title: "Where will you store it?")
    private let itemStoragePlaceTextField = CustomTextField()

    private let itemStorageNumberLabel = PopoverLabel(title: "Storage number")
    private let itemStorageNumberTextField = CustomTextField()
    
    private lazy var addButton: UIButton = { return CustomButton(title: "Add item", backgroundColor: Color.primary, borderColor: Color.primary) }()
    private lazy var addImageButton: UIButton = { return CustomButton(title: "Take picture", backgroundColor: Color.primaryBackground, borderColor: Color.primary) }()
    
    private func addView(frame: CGRect) {
        addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: self.frame.height)
        ])
        
        titleLabel.text = "Add new item"
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

        itemNameTextField.setup(placeHolder: "Tintin in the Congo")
        itemSubTextField.setup(placeHolder: "Hergé")
        itemExtraSubTextField.setup(placeHolder: "ISBN: 978-7-50-079468-4")
        itemStoragePlaceTextField.setup(placeHolder: "Garage")
        itemStorageNumberTextField.setup(placeHolder: "A2")

        dialogView.addSubview(itemNameLabel)
        dialogView.addSubview(itemNameTextField)
        dialogView.addSubview(itemSubTextField)
        dialogView.addSubview(itemExtraSubTextField)
        dialogView.addSubview(itemStoragePlaceLabel)
        dialogView.addSubview(itemStoragePlaceTextField)
        dialogView.addSubview(itemStorageNumberLabel)
        dialogView.addSubview(itemStorageNumberTextField)

        dialogView.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        dialogView.addSubview(addImageButton)
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        
        var variableHeight: CGFloat = 46
        if cellType == .basic {
            variableHeight = 0
        }

        // MARK: NSLayoutConstraint
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: Margins.medium),
            itemNameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),

            itemNameTextField.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: Margins.xSmall),
            itemNameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemNameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 46),
            
            itemSubTextField.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: Margins.xSmall),
            itemSubTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemSubTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemSubTextField.heightAnchor.constraint(equalToConstant: variableHeight),

            itemExtraSubTextField.topAnchor.constraint(equalTo: itemSubTextField.bottomAnchor, constant: Margins.xSmall),
            itemExtraSubTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemExtraSubTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemExtraSubTextField.heightAnchor.constraint(equalToConstant: variableHeight),

            itemStoragePlaceLabel.topAnchor.constraint(equalTo: itemExtraSubTextField.bottomAnchor, constant: Margins.medium),
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
            
            addImageButton.topAnchor.constraint(equalTo: itemStorageNumberTextField.bottomAnchor, constant: Margins.medium),
            addImageButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            addImageButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            addImageButton.heightAnchor.constraint(equalToConstant: 46),

            addButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: Margins.medium),
            addButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            addButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            addButton.heightAnchor.constraint(equalToConstant: 46),

            addButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -Margins.medium),
        ])
    }
    
    @IBAction private func addImageButtonTapped() {
        delegate?.addImageButtonTapped()
    }

    @IBAction private func addButtonTapped() {
        [itemNameTextField, itemStoragePlaceTextField, itemStorageNumberTextField].forEach {
            $0.layer.borderColor = Color.lightGray.cgColor
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

        guard errors.isEmpty else { return }
        
        guard let itemName = itemNameTextField.text?.lowercased(),
              let storagePlace = itemStoragePlaceTextField.text?.lowercased(),
              let storageNumber = itemStorageNumberTextField.text?.lowercased() else { return }
        
        
        delegate?.addItemButtonTapped(itemName: itemName, storagePlace: storagePlace, storageNumber: storageNumber, itemSub: itemSubTextField.text, itemExtraSub: itemExtraSubTextField.text)
    }
    
    private func addGuestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @objc func backgroundViewTapped() {
        delegate?.backgroundViewTapped()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addView(frame: self.frame)
    }
    
    init(cellType: cellType, currentCategory: Category) {
        self.cellType = cellType
        self.currentCategory = currentCategory
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        notification.addObserver(self,
                             selector: #selector(keyboardAdjust),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notification.addObserver(self,
                             selector: #selector(keyboardAdjust),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
        addGuestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notification.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
}
