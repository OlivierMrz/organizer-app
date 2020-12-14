//
//  AddCategoryViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategoryDidSave(vm: CategoryViewModel)
}

class AddCategoryViewController: UIViewController, AddCategroyViewDelegate {
    
    func addButtonTapped(categoryName: String, cellType: cellType, cellIcon: iconType) {
        let context = CoreDataManager.persistentContainer.viewContext
        let category = Category(context: context)
        category.name = categoryName.lowercased()
        category.cellType = cellType.rawValue
        category.icon = cellIcon.rawValue
        category.items = []
        
        let categoryVM = CategoryViewModel(category: category)
        
        guard let addCatDelegate = addCategoryDelegate else { return }

        do {
            try context.save()
            addCatDelegate.addCategoryDidSave(vm: categoryVM)
            dismiss(animated: true)
        } catch {
            self.presentAlert(type: .error(error.localizedDescription), completion: nil)
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
    
    
    var mainView = AddCategoryView()
    var addCategoryDelegate: AddCategoryDelegate?
    
    
    
    override func loadView() {
        super.loadView()
        mainView.delegate = self
        view = mainView
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
