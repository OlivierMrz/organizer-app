//
//  Image.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation
import UIKit

enum iconType: CaseIterable {
    case box, shelf, storage, borrowed, lent
    
    var name: String {
        switch self {
            case .box: return "box"
            case .shelf: return "shelf"
            case .storage: return "storage"
            case .borrowed: return "borrowed"
            case .lent: return "lent"
        }
    }
    
    var image: UIImage {
        switch self {
            case .box: return UIImage(named: "box")!
            case .shelf: return UIImage(named: "shelf")!
            case .storage: return UIImage(named: "storage")!
            case .borrowed: return UIImage(named: "borrowed")!
            case .lent: return UIImage(named: "lent")!
        }
    }
}

enum cellType: CaseIterable {
    case basic, subtitlePlus
    
    var name: String {
        switch self {
            case .basic: return "basic"
            case .subtitlePlus: return "subtitlePlus"
        }
    }
    
    var image: UIImage {
        switch self {
            case .basic: return UIImage(named: "basic")!
            case .subtitlePlus: return UIImage(named: "subtitlePlus")!
        }
    }
}
