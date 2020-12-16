//
//  StringProtocol+firstLetterUppercased.swift
//  Organizer
//
//  Created by Olivier Miserez on 16/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
//    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
