//
//  SelectIconViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class SelectIconListViewModel {
    var selectIconViewModels: [SelectIconViewModel]
    
    init() {
        self.selectIconViewModels = [SelectIconViewModel]()
        
        iconType.allCases.forEach { (result) in
            self.selectIconViewModels.append(SelectIconViewModel(icon: result.image))
        }
    }
    
}

extension SelectIconListViewModel {
    
    func selectIconViewModel(at index: Int) -> SelectIconViewModel {
        return self.selectIconViewModels[index]
    }
    
}

struct SelectIconViewModel {
    let icon: UIImage
}

extension SelectIconViewModel { }
