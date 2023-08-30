//
//  VC_Style0.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XDPagesView
import UIKit

class VC_Style0: UIViewController,XDPagesViewDelegate {
    lazy var pages: XDPagesView = {
        var view = XDPagesView.init(frame: CGRect.zero, config: nil, style: XDPagesPullStyle.onTop)
        return view!
    }()
    lazy var header: UIImageView = {
        let view = UIImageView.init(image: UIImage.init(named: "xd_header.jpg"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func xd_pagesViewPageTitles() -> [String]! {
        return ["1", "2"]
    }
    
    func xd_pagesView(_ pagesView: XDPagesView!, controllerFor index: Int, title: String!) -> UIViewController! {
        var indexVC = pagesView.dequeueReusablePage(for: index)
        if indexVC == nil {
            indexVC = ChildListViewController.init()
        }
        return indexVC
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.header.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.size.width, height: 200))
        pages.delegate = self;
        
        pages.pagesHeader = self.header;
        self.view.addSubview(pages)
        pages.frame = self.view.bounds
        
//        [self layoutPage];
        // 不能有重复标题
        
    }
    

}
