//
//  AddItemViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol AddItemDelegate {
    func addItemDidSave(vm: ItemViewModel)
}

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var addItemDelegate: AddItemDelegate?
    
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
    
    private var itemImage: UIImage?

    private lazy var addButton: UIButton = { return CustomButton(title: "Add item", backgroundColor: Color.primary, borderColor: Color.primary) }()
    private lazy var addImageButton: UIButton = { return CustomButton(title: "Take picture", backgroundColor: Color.primaryBackground, borderColor: Color.primary) }()
    
    private var currentCategory: Category
    private var cellType: cellType
    
    init(cellType: cellType, category: Category) {
        self.cellType = cellType
        self.currentCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let notification = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addView()
        
        
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
    
    private func addGuestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGuesture(sender:)))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func tapGuesture(sender: UITouch) {
        _ = sender.view
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
        
        titleLabel.text = "Add new item"
        subTitleLabel.text = "You can give me a number or place where you will store this item. (not required)"

        let dialogViewWidth = view.frame.width - 64
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
    
    @objc func keyboardAdjust(_ notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + view.safeAreaInsets.bottom , right: 0)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        } else {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - view.safeAreaInsets.bottom , right: 0)
        }
    }
    
    @IBAction private func addImageButtonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        present(vc, animated: true, completion: nil)
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

        guard let itemName = itemNameTextField.text,
            let storagePlace = itemStoragePlaceTextField.text,
            let storageNumber = itemStorageNumberTextField.text else { return }
        
        let context = CoreDataManager.persistentContainer.viewContext
        let item = Item(context: context)
        item.name = itemName
        item.storagePlace = storagePlace
        item.storageNumber = storageNumber
        item.category = currentCategory
        item.borrowed = false
        item.subTitle = itemSubTextField.text
        item.extraSubTitle = itemExtraSubTextField.text
        
        let itemVM = ItemViewModel(item: item)
        
        guard let addItmDelegate = addItemDelegate else { return }

        do {
            try context.save()
            addItmDelegate.addItemDidSave(vm: itemVM)
            dismiss(animated: true)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

//        print(image.size)
        itemImage = image.resizeImage(200, opaque: false)
//        print(itemImage!.size)
    }
    
    deinit {
        notification.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
}
