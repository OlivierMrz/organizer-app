//
//  ItemDetailViewController.swift
//  Organizer
//
//  Created by Olivier Miserez on 24/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    weak var coordinator: ItemDetailCoordinator?
    private let mainView = ItemDetailViewV3()
    var viewModel: ItemViewModel
    private var dataSource: ItemDetailDataSource
    private var delegate: ItemDetailDelegate
    
    override func loadView() {
        super.loadView()
        
        view = mainView
//        view.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: view.frame.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        mainView.tableView.delegate = delegate
//        mainView.tableView.dataSource = dataSource
    }
    
    init(itemViewModel: ItemViewModel) {
        self.viewModel = itemViewModel
        self.dataSource = ItemDetailDataSource(viewModel: viewModel)
        self.delegate = ItemDetailDelegate()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
