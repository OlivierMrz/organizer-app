//
//  Assets.swift
//  Organizer
//
//  Created by Olivier Miserez on 14/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

struct Color {
    static let white = UIColor(named: "White")
    static let blue = UIColor(named: "Blue")
    static let darkGray = UIColor(named: "DarkGray")
    static let midGray = UIColor(named: "MidGray")
    static let lightGray = UIColor(named: "LightGray")
}

struct Margins {
    static let xSmall: CGFloat = 2
    static let small: CGFloat = 8
    static let medium: CGFloat = 20
    static let large: CGFloat = 21
    static let xLarge: CGFloat = 38
    static let xxLarge: CGFloat = 40
    static let xxxLarge: CGFloat = 46
    static let collectionCellMargin: CGFloat = 48
    static let bigTitle: CGFloat = 80
    static let bigTitleSmallScreen: CGFloat = 30
}

struct FontWeight {
    static let regular = UIFont.Weight.regular
    static let medium = UIFont.Weight.medium
    static let bold = UIFont.Weight.bold
}

struct FontSize {
    static let xxSmall: CGFloat = 10
    static let xSmall: CGFloat = 12
    static let small: CGFloat = 14
    static let medium: CGFloat = 16
    static let large: CGFloat = 18
    static let xLarge: CGFloat = 20
    static let TitleBig: CGFloat = 62
}

struct CornerRadius {
    static let xSmall: CGFloat = 7
    static let small: CGFloat = 10
    static let medium: CGFloat = 12
    static let large: CGFloat = 14
    static let xxLarge: CGFloat = 40

    static let collectionCell: CGFloat = 16
}

struct BorderWidth {
    static let xSmall: CGFloat = 1
    static let small: CGFloat = 2
    static let medium: CGFloat = 3
    static let large: CGFloat = 4

    static let xxLarge: CGFloat = 7
}

struct ReuseIdentifier {
    static let loginCell = "LoginCell"
    static let registerCell = "RegisterCell"
    static let categoryCell = "CategoryCell"
    static let detailedCell = "DetailedCell"
    static let headerCell = "HeaderCell"
}

struct Device {
    static let IS_IPAD                  = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE                = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA                = UIScreen.main.scale >= 2.0

    static let SCREEN_WIDTH             = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT            = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH        = Int(max(SCREEN_WIDTH, SCREEN_HEIGHT))
    static let SCREEN_MIN_LENGTH        = Int(min(SCREEN_WIDTH, SCREEN_HEIGHT))

    static let IS_IPHONE_4              = IS_IPHONE && SCREEN_MAX_LENGTH <= 480 // 2, 3, 3GS, 4, 4S
    static let IS_IPHONE_5              = IS_IPHONE && SCREEN_MAX_LENGTH == 568 // 5, 5S, 5C, SE
    static let IS_IPHONE_6              = IS_IPHONE && SCREEN_MAX_LENGTH == 667 // 6, 6S, 7, 8
    static let IS_IPHONE_6P             = IS_IPHONE && SCREEN_MAX_LENGTH == 736 // 6+, 6S+, 7+, 8+
    static let IS_IPHONE_XS             = IS_IPHONE && SCREEN_MAX_LENGTH == 812 // X, XS, 11 Pro
    static let IS_IPHONE_XS_MAX         = IS_IPHONE && SCREEN_MAX_LENGTH == 896 // XR, XS Max, 11, 11 Pro Max
    static let IS_IPHONE_6P_OR_GREATHER = IS_IPHONE && SCREEN_MAX_LENGTH >= 736 // 6+, 6S+, 7+, 8+, AND greather ...
}
