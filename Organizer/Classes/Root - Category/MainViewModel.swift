//
//  MainViewModel.swift
//  Organizer
//
//  Created by Olivier Miserez on 11/12/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class MainViewModel {
    
    func headerSize(_ collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 68)
    }
    
    
    func cellSize(_ collectionView: UICollectionView) -> CGSize {
        return CGSize(width: collectionView.frame.width - Margins.collectionCellMargin, height: Margins.bigTitle)
    }
    
    var minLineSpacingCell: CGFloat {
        return 20
    }
    
    var minInteritemSpacingCell: CGFloat {
        return 0
    }
    
}
