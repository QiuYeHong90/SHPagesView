//
//  SHPageCell.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

open class SHPageCell: UITableViewCell, UIScrollViewDelegate {
    weak var mainView: SHPageView?
    var isLock: Bool = false
    var scrollEndCall: ((Int)->Void)?
    var observVCs: [SHPageChildUIViewContoller] = []
    var observScrollViews: [UIScrollView] = []
    var currentIndex: Int = 0
    lazy var scrollView: UIScrollView = {
        var view = UIScrollView()
        view.delegate = self
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCommon()
    }
    
    
    func initCommon() {
        self.selectionStyle = .none
        self.contentView.addSubview(scrollView)
        self.scrollView.isPagingEnabled = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadLayout()
    }
    
    func reload(viewContollers: [SHPageChildUIViewContoller]) {
        self.scrollView.subviews.forEach { item in
            item.removeFromSuperview()
        }
        
        observVCs = viewContollers
        
        viewContollers.enumerated().forEach { item in
            self.scrollView.addSubview(item.element.view)
            item.element.view.tag = item.offset
            
        }
        
        reloadLayout()
    }
    
    func clearKVO() {
        observScrollViews.forEach { item in
            item.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        }
        observScrollViews = []
    }
    
    func addKVO() {
        
        observScrollViews.forEach { item in
//            NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
            
            item.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.old,.new], context: nil)
        }
    }
    
    func reloadLayout() {
        scrollView.frame = self.bounds
        self.scrollView.subviews.enumerated().forEach { item in
            item.element.frame = CGRect.init(origin: CGPoint.init(x: CGFloat(item.offset) * self.bounds.size.width, y: 0), size: self.bounds.size)
        }
        self.scrollView.contentSize = CGSize(width: CGFloat(self.scrollView.subviews.count) * self.bounds.size.width, height: 0)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func scrollTo(index: Int, animated: Bool = true) {
        currentIndex = index
        var x = self.bounds.size.width * CGFloat(index)
        
        self.scrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: animated)
        self.reloadKVOIndex(index: index)
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadKVOIndex(index: Int) {
        self.clearKVO()
//        let scrollViews = item.element.shGetAllInteractScrollView()
//        observScrollViews.append(contentsOf: scrollViews)
        if self.observVCs.count <= index {
            return
        }
        self.observScrollViews = self.observVCs[index].shGetAllInteractScrollView()
        self.addKVO()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var index = Int(floor(scrollView.contentOffset.x / self.bounds.size.width ))
        index = max(0, index)
        reloadKVOIndex(index: index)
        scrollEndCall?(index)
    }

    deinit {
        print("deinit == \(self)")
        self.clearKVO()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(UIScrollView.contentOffset), let kvoScrollView = object as? UIScrollView {
            
            guard let oldPoint = change?[NSKeyValueChangeKey.oldKey] as? CGPoint else {
                return
            }
            guard let newPoint = change?[NSKeyValueChangeKey.newKey] as? CGPoint else {
                return
            }
            if newPoint == oldPoint {
                return
            }
            let isMainLock = mainView?.isMainLock ?? false
            let mainY = mainView?.tableView.contentOffset.y ?? 0
            print("oldPoint == \(oldPoint) newPoint == \(newPoint) \(kvoScrollView.contentOffset) mainY = \(mainY)")
            if kvoScrollView.contentOffset.y <= 0 {
                kvoScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
                isLock = true
            } else {
                isLock = false
            }
            
            self.scrollView.isScrollEnabled = false
            if isMainLock {
//                向上滑动到极限了
                return
            }
            
            kvoScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
            
            
        }
    }
}
