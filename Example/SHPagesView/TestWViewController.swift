//
//  TestWViewController.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SHPagesView
import MJRefresh
import SnapKit
import UIKit

class TestWViewController: UIViewController, SHPageViewDelegate {
    
    
    var childList: [SHPageChildUIViewContoller] = []
    
    
    func shPagedataSourceViewController(pageView: SHPageView) -> [SHPageChildUIViewContoller] {
        return self.childList
    }
    
    lazy var pageView: SHPageView = {
        var view = SHPageView()
        return view
    }()
    lazy var header: CustomHeader = {
        let view = CustomHeader.loadViewFromNib()
        view.tapCall = {
            [weak self] in
            let toVC = ChildListViewController.init()
            
            self?.navigationController?.pushViewController(toVC, animated: true)
        }
        return view
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        self.header.clipsToBounds = true
        self.header.contentMode = .scaleAspectFill
        self.header.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.bounds.size.width, height: 200))
        pageView.setHeader(header: self.header)
        pageView.delegate = self
//        self.pageView
        
        do {
            let toVC = ChildListViewController.init()
            toVC.title = "Test1"
            self.addChild(toVC)
            self.childList.append(toVC)
        }
        do {
            let toVC = ChildListViewController.init()
            toVC.title = "Test2"
            toVC.tableView.backgroundColor = .black
            self.addChild(toVC)
            self.childList.append(toVC)
        }
        pageView.reloadConfig()
        
        
        pageView.tableView.mj_header = MJRefreshNormalHeader.init {
            let value = Date.init().timeIntervalSince1970 + 10
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: DispatchWorkItem.init(block: {
                [weak self] in
                self?.pageView.tableView.mj_header?.endRefreshing()
            }))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
