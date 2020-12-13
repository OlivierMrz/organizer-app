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

//        print(image.size)
        itemImage = image.resizeImage(200, opaque: false)
//        print(itemImage!.size)
    }
    
    func addItemButtonTapped(itemName: String, storagePlace: String, storageNumber: String, itemSub: String?, itemExtraSub: String?) {
        let imageData = itemImage?.pngData()
        
        let context = CoreDataManager.persistentContainer.viewContext
        let item = Item(context: context)
        item.name = itemName
        item.storagePlace = storagePlace
        item.storageNumber = storageNumber
        item.category = currentCategory
        item.borrowed = false
        item.subTitle = itemSub
        item.extraSubTitle = itemExtraSub
        item.image = String(describing: imageData)
        
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


//func getCurrentViewController() -> UIViewController? {
//    let currentWindow: UIWindow? = UIApplication.shared.connectedScenes
//        .filter({$0.activationState == .foregroundActive})
//        .map({$0 as? UIWindowScene})
//        .compactMap({$0})
//        .first?.windows
//        .filter({$0.isKeyWindow}).first
//
//    if let sceneRootController = currentWindow {
//        var currentController: UIViewController! = sceneRootController.rootViewController
//        while currentController.presentedViewController != nil {
//            currentController = currentController.presentedViewController
//        }
//        return currentController
//    }
//    return nil
//}
