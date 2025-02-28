//  Copyright © 2017 SkeletonView. All rights reserved.

import UIKit

public extension UIView {
    
    @objc var isAddLayer: Bool {
        return true
    }
    
    @IBInspectable
    var isSkeletonable: Bool {
        get { return skeletonable }
        set { skeletonable = newValue }
    }
    
    var isSkeletonActive: Bool {
        return status == .on || (subviewsSkeletonables.first(where: { $0.isSkeletonActive }) != nil)
    }

    fileprivate var skeletonable: Bool! {
        get { return ao_get(pkey: &ViewAssociatedKeys.skeletonable) as? Bool ?? false }
        set { ao_set(newValue ?? false, pkey: &ViewAssociatedKeys.skeletonable) }
    }
}

