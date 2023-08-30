//
//  SHSectionBarItemCell.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SHSectionBarItemCell: UICollectionViewCell {
    var tapCall: (()->Void)?
    
    lazy var titleLabel: UILabel = {
        var view = UILabel()
        view.text = ""
        view.textColor = UIColor(red: 0.9, green: 0.89, blue: 0.89, alpha: 1)
        view.font = .systemFont(ofSize: 13)
        view.textAlignment = .center
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        
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
}
