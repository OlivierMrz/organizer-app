//
//  DevModeView.swift
//  Organizer
//
//  Created by Olivier Miserez on 30/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

protocol DevModeDelegate {
//    func devAddCategory()
//    func devAddItem()
    func devGoToItemDetail()
}

class DevModeView: UIView {
    
    var delegate: DevModeDelegate?
    
    private lazy var addCategroyButton: UIButton = {
        let b = CustomButton(title: "Add Category", backgroundColor: .white, borderColor: .black)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    @objc private func addCategoryButtonTapped() {
        print("add cat tapped")
    }
    
    private lazy var addItemButton: UIButton = {
        let b = CustomButton(title: "Add Item", backgroundColor: .white, borderColor: .black)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    @objc private func addItemButtonTapped() {
        print("add Item tapped")
    }
    
    private lazy var itemDetailButton: UIButton = {
        let b = CustomButton(title: "Item Detail", backgroundColor: .white, borderColor: .black)
        b.setTitleColor(.black, for: .normal)
        return b
    }()
    
    @objc private func goToItemButtonTapped() {
        delegate?.devGoToItemDetail()
    }
    
    private func setup() {
        layer.cornerRadius = CornerRadius.large
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        addSubview(addCategroyButton)
        addCategroyButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addCategroyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            addCategroyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            addCategroyButton.heightAnchor.constraint(equalToConstant: 60),
            addCategroyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
        ])
        
        addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            addItemButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            addItemButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            addItemButton.heightAnchor.constraint(equalToConstant: 60),
            addItemButton.topAnchor.constraint(equalTo: addCategroyButton.bottomAnchor, constant: 25),
        ])
        
        addSubview(itemDetailButton)
        itemDetailButton.addTarget(self, action: #selector(goToItemButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            itemDetailButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            itemDetailButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            itemDetailButton.heightAnchor.constraint(equalToConstant: 60),
            itemDetailButton.topAnchor.constraint(equalTo: addItemButton.bottomAnchor, constant: 25),
        ])
    }

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
