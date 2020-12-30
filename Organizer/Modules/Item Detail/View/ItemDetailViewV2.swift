//
//  ItemDetailViewV2.swift
//  Organizer
//
//  Created by Olivier Miserez on 18/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailViewV2: UIView {
    
    let imageview: UIImageView = {
        let i = UIImageView()
        i.backgroundColor = Color.lightGray
        i.contentMode = .scaleAspectFit
        i.image = UIImage(named: "placeholder")
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = Color.primaryBackground
        v.layer.cornerRadius = CornerRadius.large
        v.clipsToBounds = true
        v.layer.masksToBounds = false
        v.layer.shadowRadius = 7
        v.layer.shadowOpacity = 0.6
        v.layer.shadowOffset = CGSize(width: 0, height: 5)
        v.layer.shadowColor = UIColor.darkGray.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Title label text"
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge + 4, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let itemSubLabel: UILabel = {
        let l = UILabel()
        l.text = "Sub Title label text"
        l.textColor = Color.darkGray
        l.font = UIFont.systemFont(ofSize: FontSize.xLarge, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let itemExtraSubLabel: UILabel = {
        let l = UILabel()
        l.text = "Extra Sub Title label text"
        l.textColor = Color.midGray
        l.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let detailLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.systemFont(ofSize: FontSize.small, weight: FontWeight.regular)
        v.numberOfLines = 0
        v.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam ipsum mauris, condimentum quis quam id, pretium posuere augue. Donec tincidunt tempor tempor. Donec porta lorem arcu, a bibendum tortor congue sed. Proin in mauris vulputate, gravida odio et, aliquam lectus. Nam molestie, lorem suscipit pulvinar hendrerit, nisi orci pharetra augue."
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let itemStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .fill
        s.axis = .vertical
        s.distribution = .equalCentering
        s.spacing = 0
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    let storageLabel: UILabel = {
        let l = UILabel()
        l.text = "Garage"
        l.textColor = Color.midGray
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let storageNumberLabel: UILabel = {
        let l = UILabel()
        l.text = "A1"
        l.textColor = Color.primaryBackground
        l.backgroundColor = Color.darkGray
        l.layer.cornerRadius = CornerRadius.xSmall
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: FontSize.xSmall, weight: FontWeight.medium)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let placeStackView: UIStackView = {
        let s = UIStackView()
        s.alignment = .center
        s.axis = .vertical
        s.distribution = .fillProportionally
        s.spacing = 3
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var lentOutButton: CustomButton = {
        let b = CustomButton()
        b.setup(title: "Lent out", backgroundColor: Color.primary, borderColor: Color.primary)
        return b
    }()

    private func setup() {
        backgroundColor = Color.primaryBackground
        addSubview(imageview)
        insertSubview(scrollView, aboveSubview: imageview)
        scrollView.addSubview(backgroundView)
        
        backgroundView.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            imageview.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            imageview.heightAnchor.constraint(equalToConstant: 240),
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: scrollView.frame.height)
        ])
        
        NSLayoutConstraint.activate([
//            mainView.heightAnchor.constraint(equalToConstant: 300),
            mainView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
            mainView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            mainView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 220)
        ])
        
        itemStackView.addArrangedSubview(titleLabel)
        itemStackView.addArrangedSubview(itemSubLabel)
        itemStackView.addArrangedSubview(itemExtraSubLabel)

        placeStackView.addArrangedSubview(storageLabel)
        placeStackView.addArrangedSubview(storageNumberLabel)

        mainView.addSubview(itemStackView)
        mainView.addSubview(placeStackView)
        mainView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            itemStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
            itemStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 30),
//            itemStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 0),
            itemStackView.trailingAnchor.constraint(equalTo: placeStackView.leadingAnchor, constant: -10),

//            placeStackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: -2),
            placeStackView.topAnchor.constraint(equalTo: itemStackView.topAnchor, constant: -5),
            placeStackView.widthAnchor.constraint(equalToConstant: 74),
            placeStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -14),

            storageLabel.heightAnchor.constraint(equalToConstant: 22),

            storageNumberLabel.heightAnchor.constraint(equalToConstant: 37),
            storageNumberLabel.widthAnchor.constraint(equalToConstant: 37),
            
            detailLabel.topAnchor.constraint(equalTo: itemStackView.bottomAnchor, constant: 15),
            detailLabel.leadingAnchor.constraint(equalTo: itemStackView.leadingAnchor, constant: 0),
            detailLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -30),
//            detailLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        mainView.addSubview(lentOutButton)

        NSLayoutConstraint.activate([
            lentOutButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 25),
            lentOutButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
            lentOutButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
            lentOutButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
            lentOutButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
//        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
