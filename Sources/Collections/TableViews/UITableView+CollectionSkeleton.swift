//
//  UITableView+CollectionSkeleton.swift
//  SkeletonView-iOS
//
//  Created by Juanpe Catalán on 02/02/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

extension UITableView: CollectionSkeleton {
    
    public override var isAddLayer: Bool {
        return false
    }
    
    
    var estimatedNumberOfRows: Int {
        return Int(ceil(frame.height/rowHeight))
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
        guard let originalDataSource = self.dataSource as? SkeletonTableViewDataSource,
            !(originalDataSource is SkeletonCollectionDataSource)
            else { return }
        let rowHeight = calculateRowHeight()
        let dataSource = SkeletonCollectionDataSource(tableViewDataSource: originalDataSource,
                                                      rowHeight: rowHeight)
        self.skeletonDataSource = dataSource
        reloadData()
    }
    
    func removeDummyDataSource(reloadAfter: Bool) {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        restoreRowHeight()
        self.skeletonDataSource = nil
        self.dataSource = dataSource.originalTableViewDataSource
        if reloadAfter { self.reloadData() }
    }

    private func restoreRowHeight() {
        guard let dataSource = self.dataSource as? SkeletonCollectionDataSource else { return }
        rowHeight = dataSource.rowHeight
    }
    
    private func calculateRowHeight() -> CGFloat {
        guard rowHeight == UITableView.automaticDimension else { return rowHeight }
        rowHeight = estimatedRowHeight
        return estimatedRowHeight
    }
}
extension UITableViewCell {
    public override var isAddLayer: Bool {
        return false
    }
}
