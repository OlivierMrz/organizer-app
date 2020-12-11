//
//  CategoryPopOverViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategoryDidSave(vm: CategoryViewModel)
}

class CategoryPopOverViewController: UIViewController, SelectIconDelegate, SelectCellTypeDelegate {
    
    var addCategoryDelegate: AddCategoryDelegate?
    
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

    private let categoryNameTextField = CustomTextField()
    private let selectIconButton = UIImageView()
    private let selectIcon = PopoverLabel(title: "Choose category icon")
    private let selectCellTypeButton = UIImageView()

    private lazy var addButton: UIButton = { return CustomButton(title: "Add Category", backgroundColor: Color.primary!, borderColor: Color.primary!) }()

    private var selectedCellType: cellType?
    private var selectedCellIcon: iconType?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        view.isOpaque = true
        
        addView()
        
        let notification = NotificationCenter.default
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
    
    @objc func keyboardAdjust(_ notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    private func addGuestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGuesture(sender:)))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func tapGuesture(sender: UITouch) {
        let x = sender.view
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: DidSelectCell ICON
    internal func didSelectCell(icon: iconType) {
        selectedCellIcon = icon
        selectIconButton.layer.borderColor = Color.lightGray?.cgColor
        selectIconButton.image = icon.image
    }

    // MARK: DidSelectCell TYPE
    internal func didSelectCell(type: cellType) {
        selectedCellType = type
        selectCellTypeButton.layer.borderColor = Color.lightGray?.cgColor
        selectCellTypeButton.image = type.image
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
        
        titleLabel.text = "Add new category"
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

        let categoryNameLabel = PopoverLabel(title: "Category name")

        categoryNameTextField.setup(placeHolder: "Books")

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

        let selectCellTypeLabel = PopoverLabel(title: "Choose cell type")

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

        guard let icon = selectedCellIcon, let cell = selectedCellType, errors.isEmpty else { return }

        let catName = categoryNameTextField.text!.lowercased()

        let context = CoreDataManager.persistentContainer.viewContext
        let category = Category(context: context)
        category.name = catName
        category.cellType = cell.name
        category.icon = icon.name
        category.items = []
        
        let categoryVM = CategoryViewModel(category: category)
        
        guard let addCatDelegate = addCategoryDelegate else { return }

        do {
            try context.save()
            addCatDelegate.addCategoryDidSave(vm: categoryVM)
            dismiss(animated: true)
        } catch {
            fatalError(error.localizedDescription)
        }

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
    
    @IBAction private func selectCellTapped() {
        let vc = SelectCellTypeViewController()
//        let currentController = getCurrentViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction private func selectIconTapped() {
        let vc = SelectIconViewController()
//        let currentController = getCurrentViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}
