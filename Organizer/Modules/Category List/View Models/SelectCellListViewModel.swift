//
//  SelectCellListViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 09/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class SelectCellListViewModel {
    var selectCellViewModels: [SelectCellViewModel]
    
    init() {
        self.selectCellViewModels = [SelectCellViewModel]()
        
        cellType.allCases.forEach { (result) in
            self.selectCellViewModels.append(SelectCellViewModel(image: result.image))
        }
    }
    
}

extension SelectCellListViewModel {
    
    func selectCellViewModel(at index: Int) -> SelectCellViewModel {
        return self.selectCellViewModels[index]
    }
    
}

struct SelectCellViewModel {
    let image: UIImage
}

extension SelectCellViewModel { }
