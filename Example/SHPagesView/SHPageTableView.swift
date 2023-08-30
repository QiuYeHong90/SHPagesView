//
//  SHPageTableView.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SHPageTableView: UITableView,UIGestureRecognizerDelegate {

    var isAllow: Bool = true
    
//    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//        return self.gesturePublic;
//    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizer === \(isAllow) \(gestureRecognizer) == \(otherGestureRecognizer) ")
        return isAllow
    }
    
    
}
