//
//  SHPageView.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
import SnapKit
import UIKit

public protocol SHPageChildUIViewContoller: UIViewController {
    func shGetAllInteractScrollView() -> [UIScrollView];
}

public protocol SHPageViewDelegate: NSObjectProtocol {
    func shPagedataSourceViewController(pageView: SHPageView) -> [SHPageChildUIViewContoller];
    
}

public class SHPageView: UIView {
    public lazy var tableView: SHPageTableView = {
        let tableView = SHPageTableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var topMaxY: CGFloat = 0
    
    
    public lazy var secitonBarView: SHSectionBar = {
        var view = SHSectionBar()
        view.didTapItemCall = {
            [weak self] index in
            self?.pageCell?.scrollTo(index: index)
        }
        return view
    }()
    
    var _mainOffsetStatic: CGFloat = 0
    var isMainLock: Bool = false
    
    
    var sectionHeight: CGFloat = 44 {
        didSet {
            self.tableView.reloadData()
        }
    }
    var pageCell: SHPageCell?
    
    public weak var delegate: SHPageViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
        self.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        self.tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.contentInset = .zero
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(SHPageCell.self, forCellReuseIdentifier: "\(SHPageCell.self)")
        
    
    }
    public func setHeader(header: UIView?, animation: Bool = false) {
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = header
        if animation {
            UIView.animate(withDuration: 0.25) {
                self.tableView.layoutIfNeeded()
            }
        }
        
    }
    
    public func reloadConfig() {
        let list = self.delegate?.shPagedataSourceViewController(pageView: self) ?? []
        let listTitles = list.map { item in
            return item.title ?? ""
        }
        self.secitonBarView.dataArray = listTitles
        
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.reloadData()
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        print("view == \(view == self.tableView) = \(view) ==\(view?.isDescendant(of: self.secitonBarView))")
        
//        let isSectionDescendant = view?.isDescendant(of: self.secitonBarView) ?? false
//        if isSectionDescendant {
//            self.tableView.isAllow = true
//        } else {
//            self.tableView.isAllow = true
//        }
        
        
//        print("view ==1 \(view == self.pageCell?.scrollView)")
//        print("view ==2 \(view == self.pageCell?.contentView)")
        
//        UIView *view = [super hitTest:point withEvent:event];
        
//        let relative_point = [self.pagesContainer convertPoint:point fromView:self];
//        self.secitonBarView
        
        
//        [self scrollViewDidScroll:self.mainTable];
        
        
        return view
    }
    /**
     {
         if (!scrollView) {
             return;
         }
         
         if (scrollView.contentOffset.y > _canChangeHeight) {
             scrollView.contentOffset = CGPointMake(0, _canChangeHeight);
         }
         if (self.pagesPullStyle == XDPagesPullOnCenter) {
             if (scrollView.contentOffset.y <= 0) {
                 scrollView.contentOffset = CGPointMake(0, 0);
             }
         }
         
         // 如果滚动方向改变，先把主列表锁定，然后通过子view滚动去判断是否解锁，已达到主列表自由滚动响应延后的目的，取出垂直滚动代理脏数据
         if (_isCurrentPageCanScroll) {
             if (_mainOffsetStatic < scrollView.contentOffset.y) {
                 if (self.s_status != XDPages_Up) {
                     self.s_status = XDPages_Up;
                     _needLockOffset = YES;
                 }
             } else if (_mainOffsetStatic > scrollView.contentOffset.y) {
                 if (self.s_status != XDPages_Down) {
                     self.s_status = XDPages_Down;
                     _needLockOffset = YES;
                 }
             }
         }
         
         if (_needLockOffset && _mainTable.gesturePublic) {
             
             CGFloat offsety = [self lockMainTableAtOffsety:_mainOffsetStatic needLock:YES];
             
             if (offsety >= 0) {
                 scrollView.contentOffset = CGPointMake(0, offsety);
             } else {
                 [self lockMainTableAtOffsety:scrollView.contentOffset.y needLock:NO];
             }

         } else {
             [self lockMainTableAtOffsety:scrollView.contentOffset.y needLock:NO];
         }

         _mainOffsetStatic = scrollView.contentOffset.y;
         if ([self.delegate respondsToSelector:@selector(xd_pagesViewVerticalScrollOffsetyChanged:isCeiling:)]) {
             [self.delegate xd_pagesViewVerticalScrollOffsetyChanged:_mainOffsetStatic isCeiling:floor(_mainOffsetStatic) >= floor(_canChangeHeight)];
         }
     }
     */

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.sectionHeight
        
//        if (scrollView.contentOffset.y <= 0) {
//            scrollView.contentOffset = CGPointMake(0, 0);
//        }
//        scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        
        let headerHeight = self.tableView.tableHeaderView?.bounds.size.height ?? 0
        print("scrollView11 = == \(scrollView.contentOffset) headerHeight =")
        topMaxY = headerHeight - self.safeAreaInsets.top
        if topMaxY < scrollView.contentOffset.y {
            scrollView.contentOffset = CGPointMake(0, topMaxY);
            isMainLock = true
        }
        
        if scrollView.contentOffset.y > _mainOffsetStatic {
//            向上
            print("scrollView11 向上== \(scrollView.contentOffset)")
            
        } else {
//            向下
            print("scrollView11 向下== \(scrollView.contentOffset) headerHeight = \(headerHeight)")
            let itemIsLock = self.pageCell?.isLock ?? false
            if itemIsLock {
                if topMaxY > scrollView.contentOffset.y {
                    isMainLock = false
                }
                return
            }
            if isMainLock {
                print("_mainOffsetStatic == \(_mainOffsetStatic) == \(topMaxY) = \(scrollView.contentOffset.y)")
//                if scrollView.contentOffset.y == topMaxY {
//
//                } else {
//
//                    scrollView.contentOffset = CGPointMake(0, topMaxY);
//
//                }
                self.pageCell?.scrollView.isScrollEnabled = true
                scrollView.contentOffset = CGPointMake(0, topMaxY);
                
            }
        }
        
        
        _mainOffsetStatic = scrollView.contentOffset.y
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageCell?.scrollView.isScrollEnabled = true
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        self.pageCell?.scrollView.isScrollEnabled = true
    }
}
extension SHPageView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.pageCell {
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SHPageCell.self)", for: indexPath) as! SHPageCell
        cell.backgroundColor = .red
        cell.mainView = self
        cell.scrollEndCall = {
            [weak self] item in
            self?.secitonBarView.scrollTo(index: item)
        }
        let list = self.delegate?.shPagedataSourceViewController(pageView: self) ?? []
        cell.reload(viewContollers: list)
        cell.scrollTo(index: self.secitonBarView.selectIndex)
        self.pageCell = cell
        return cell
    }
    
    
}
extension SHPageView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("self.tableView.bounds.size.height == \(self.tableView.bounds.size.height)")
        return self.tableView.bounds.size.height - sectionHeight - self.safeAreaInsets.top - self.safeAreaInsets.bottom
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return secitonBarView
    }
}
