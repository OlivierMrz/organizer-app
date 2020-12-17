//
//  AddCategoryViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategoryDidSave(vm: CategoryViewModel?)
}

class AddCategoryViewController: UIViewController, AddCategroyViewDelegate {
        
    var editCategory: Category?
    var mainView: AddCategoryView?
    var addCategoryDelegate: AddCategoryDelegate?
    
    override func loadView() {
        super.loadView()
        mainView = AddCategoryView(editCategory: editCategory)
        mainView?.delegate = self
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func addButtonTapped(categoryName: String, cellType: cellType, cellIcon: iconType) {
        guard let addCatDelegate = addCategoryDelegate else { return }
        
        if let editedCategory = editCategory {
            editedCategory.name = categoryName
            editedCategory.cellType = cellType.rawValue
            editedCategory.icon = cellIcon.rawValue
            CoreDataManager.shared.saveEdited(category: editedCategory)
            addCatDelegate.addCategoryDidSave(vm: nil)
            dismiss(animated: true)
        } else {
        
            guard CoreDataManager.shared.doesCategoryAlreadyExist(categoryName) == false else {
                self.presentAlert(type: .duplication(categoryName), completion: nil)
                return
            }
            
            let context = CoreDataManager.persistentContainer.viewContext
            let category = Category(context: context)
            category.name = categoryName.lowercased()
            category.cellType = cellType.rawValue
            category.icon = cellIcon.rawValue
            category.items = []
            
            let categoryVM = CategoryViewModel(category: category)

            do {
                try context.save()
                addCatDelegate.addCategoryDidSave(vm: categoryVM)
                dismiss(animated: true)
            } catch {
                self.presentAlert(type: .error(error.localizedDescription), completion: nil)
            }
            
        }
    }
    
    func backgroundViewTapped() {
        presentAlert(type: .custom(title: "⚠️ Warning", text: "Are you sure you want to cancel?")) {
            self.dismiss(animated: true)
        }
    }
    
    func selectCellTapped() {
        let vc = SelectCellTypeViewController()
        vc.delegate = mainView
        self.present(vc, animated: true, completion: nil)
    }
    
    func selectIconTapped() {
        let vc = SelectIconViewController()
        vc.delegate = mainView
        self.present(vc, animated: true, completion: nil)
    }
    
    init(category: Category? = nil) {
        self.editCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
