//
//  SkeletonCollectionDelegate.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 30/03/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

class SkeletonCollectionDelegate: NSObject {
    
    weak var originalTableViewDelegate: SkeletonTableViewDelegate?
    weak var originalCollectionViewDelegate: SkeletonCollectionViewDelegate?
    
    init(tableViewDelegate: SkeletonTableViewDelegate? = nil, collectionViewDelegate: SkeletonCollectionViewDelegate? = nil) {
        self.originalTableViewDelegate = tableViewDelegate
        self.originalCollectionViewDelegate = collectionViewDelegate
    }
}

// MARK: - UITableViewDataSource
extension SkeletonCollectionDelegate: UITableViewDelegate { }

// MARK: - UICollectionViewDataSource
extension SkeletonCollectionDelegate: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = self.originalCollectionViewDelegate as? UICollectionViewDelegateFlowLayout {
            return layout.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize.zero
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isSkeletonActive {
            if !cell.isSkeletonActive {
                DispatchQueue.main.async {
                    cell.showAnimatedGradientSkeleton()
                }
            }
        }
    }
}
