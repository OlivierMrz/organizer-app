//
//  DetailedPopOverViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 10/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class DetailedPopOverViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var addItemDelegate: AddItemDelegate?
    
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
    private var itemImageUrl: String?

    let addButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Add item", backgroundColor: Color.primary!, borderColor: Color.primary!)
        return b
    }()
    
    private let addImageButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Take picture", backgroundColor: Color.primaryBackground!, borderColor: Color.primary!)
        return b
    }()
    
    private var currentCategory: Category
    
    init(category: Category) {
        self.currentCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        view.isOpaque = true
        
        addView()
        
    }
    
    private func addView() {
        titleLabel.text = "Add new item"
        subTitleLabel.text = "You can give me a number or place where you will store this item. (not required)"

        let dialogViewWidth = view.frame.width - 64
        view.addSubview(dialogView)
        NSLayoutConstraint.activate([
            dialogView.widthAnchor.constraint(equalToConstant: dialogViewWidth),
            dialogView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            dialogView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
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
            itemSubTextField.heightAnchor.constraint(equalToConstant: 46),

            itemExtraSubTextField.topAnchor.constraint(equalTo: itemSubTextField.bottomAnchor, constant: Margins.xSmall),
            itemExtraSubTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            itemExtraSubTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            itemExtraSubTextField.heightAnchor.constraint(equalToConstant: 46),

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
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        present(vc, animated: true, completion: nil)
    }
    
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
        
        let itemVM = itemViewModel(item: item)
        
        guard let addItmDelegate = addItemDelegate else { return }

        do {
            try context.save()
            addItmDelegate.addItemDidSave(vm: itemVM)
            dismiss(animated: true)
        } catch {
            fatalError(error.localizedDescription)
        }

        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        print(image.size)
        itemImage = image.resizeImage(200, opaque: false)
        print(itemImage!.size)
    }
}