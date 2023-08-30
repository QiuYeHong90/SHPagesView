//
//  TestTableViewCell.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/30.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    var tapCall: (()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
        /**
         @objc func tapClick(sender: Any) {
         
         }
         */
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapClick(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapClick(sender: Any) {
        tapCall?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
