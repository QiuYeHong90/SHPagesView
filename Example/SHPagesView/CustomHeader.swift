//
//  CustomHeader.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class CustomHeader: UIView {
    var tapCall: (()->Void)?
    
    
    static func loadViewFromNib() -> CustomHeader {
        let view = Bundle.main.loadNibNamed("\(CustomHeader.self)", owner: nil)?.first as! CustomHeader
        return view
    }
    @IBAction func tapClcik(_ sender: Any) {
        print("===diaji tap")
    }
    
    @IBAction func btnCLick(_ sender: Any) {
        print("===diaji")
        
        tapCall?()
    }
    
}
