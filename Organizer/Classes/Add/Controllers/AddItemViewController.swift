//
//  AddItemViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemDelegate {
    func addItemDidSave(vm: ItemViewModel)
}

class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, addItemViewDelegate {

    var mainView: AddItemView?
    var addItemDelegate: AddItemDelegate?
    private var currentCategory: Category
    private var itemImage: UIImage?
    
    fileprivate lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .savedPhotosAlbum
        picker.delegate = self

        return picker
    }()
    
    override func loadView() {
        super.loadView()
        mainView?.delegate = self
        view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        itemImage = image.resizeImage(200, opaque: false)
    }
    
    func addItemButtonTapped(itemName: String, storagePlace: String, storageNumber: String, itemSub: String?, itemExtraSub: String?) {
        
        let context = CoreDataManager.persistentContainer.viewContext
        let item = Item(context: context)
        item.name = itemName
        item.storagePlace = storagePlace
        item.storageNumber = storageNumber
        item.category = currentCategory
        item.borrowed = false
        item.subTitle = itemSub
        item.extraSubTitle = itemExtraSub
        item.imageData = itemImage?.pngData()
        
        let itemVM = ItemViewModel(item: item)
        
        guard let addItmDelegate = addItemDelegate else { return }

        do {
            try context.save()
            addItmDelegate.addItemDidSave(vm: itemVM)
            dismiss(animated: true)
        } catch {
            self.presentAlert(type: .error(error.localizedDescription), completion: nil)
        }
    }

    func addImageButtonTapped() {
        imagePicker.modalPresentationStyle = .overFullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    init(cellType: cellType, category: Category) {
        self.mainView = AddItemView(cellType: cellType, currentCategory: category)
        self.currentCategory = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
