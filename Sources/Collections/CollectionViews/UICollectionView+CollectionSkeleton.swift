//
//  UICollectionView+CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

extension UICollectionView: CollectionSkeleton {
    
    public override var isAddLayer: Bool {
        return false
    }
    
    var estimatedNumberOfRows: Int {
        guard let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        return Int(ceil(frame.height/flowlayout.itemSize.height))
    }
    
    var skeletonDataSource: SkeletonCollectionDataSource? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDataSource) as? SkeletonCollectionDataSource }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDataSource)
            self.dataSource = newValue
        }
    }
    
    var skeletonDelegate: SkeletonCollectionDelegate? {
        get { return ao_get(pkey: &CollectionAssociatedKeys.dummyDelegate) as? SkeletonCollectionDelegate }
        set {
            ao_setOptional(newValue, pkey: &CollectionAssociatedKeys.dummyDelegate)
            self.delegate = newValue
        }
    }
    
    func addDummyDataSource() {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource)
        self.skeletonDataSource = dataSource
        
        if let originalDelegate = self.delegate as? SkeletonCollectionViewDelegate, !(originalDelegate is SkeletonCollectionDelegate) {
            let delegate = SkeletonCollectionDelegate(collectionViewDelegate: originalDelegate)
            self.skeletonDelegate = delegate
        }
        reloadData()
    }
    
    func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        self.skeletonDataSource = nil
        self.dataSource = dataSource.originalCollectionViewDataSource
        if let del = self.delegate as? SkeletonCollectionDelegate {
            self.skeletonDelegate = nil
            self.delegate = del.originalCollectionViewDelegate
        }
        if reloadAfter { self.reloadData() }
    }
}

extension UICollectionView: GenericCollectionView {
    var scrollView: UIScrollView { return self }
}

public extension UICollectionView {
    func prepareSkeleton(completion: @escaping (Bool) -> Void) {
        guard let originalDataSource = self.dataSource as? SkeletonCollectionViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        
        let dataSource = SkeletonCollectionDataSource(collectionViewDataSource: originalDataSource, rowHeight: 0.0)
        self.skeletonDataSource = dataSource
        performBatchUpdates({
            self.reloadData()
        }) { (done) in
            completion(done)
            
        }
    }
}
extension UICollectionViewCell {
    public override var isAddLayer: Bool {
        return false
    }
}

