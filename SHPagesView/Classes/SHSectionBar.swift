//
//  SHSectionBar.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

public class SHSectionBar: UIView {
    var didTapItemCall: ((Int)->Void)?
    
    
    private(set) var selectIndex: Int = 0
    
    lazy var followLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let coll = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: followLayout)
        return coll
    }()
    
    public lazy var markView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.09, blue: 0.09, alpha: 1)
        return view
    }()
    
    public lazy var bottomLineView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.89, blue: 0.89, alpha: 1)
        return view
    }()
    
    
    var dataArray: [String] = [] {
        didSet {
            reloadUI()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCommon()
    }
    
    func initCommon() {
        self.addSubview(bottomLineView)
        self.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        collectionView.bounces = false
        collectionView.register(SHSectionBarItemCell.self, forCellWithReuseIdentifier: "SHSectionBarItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView.addSubview(markView)
        
        
        bottomLineView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        reloadUI()
        
    }
    
    func reloadUI() {
        if !self.dataArray.isEmpty {
            let itemW = floor(self.bounds.size.width / CGFloat(self.dataArray.count))
            let itemH = self.bounds.size.height
            self.followLayout.itemSize = CGSize.init(width: itemW, height: itemH)
            followLayout.minimumLineSpacing = 0
            followLayout.minimumInteritemSpacing = 0
            followLayout.sectionInset = .zero
            
            markView.bounds = CGRect.init(x: 0, y: 0, width: itemW, height: 1)
            
        }
        self.markViewAnimate(index: self.selectIndex, animate: false)
        self.collectionView.reloadData()
    }
    
    func setSelcted(index: Int) {
        self.selectIndex = index
        self.markViewAnimate(index: index, animate: true)
        self.collectionView.reloadData()
        
    }
    
    func scrollTo(index: Int, animated: Bool = true) {
        self.selectIndex = index
        
//        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: animated)
        self.markViewAnimate(index: index, animate: animated)
        self.collectionView.reloadData()
    }
    
    func markViewAnimate(index: Int,animate: Bool = false) {
        if let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) {
            let rect = CGRect.init(x: cell.frame.origin.x, y: cell.frame.maxY - 1, width: cell.frame.size.width, height: 1)
            if animate {
                UIView.animate(withDuration: 0.25) {
                    self.markView.frame = rect
                }
            } else {
                markView.frame = rect
            }
        }
        
        
    }
}

extension SHSectionBar: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SHSectionBarItemCell", for: indexPath) as! SHSectionBarItemCell
        cell.tapCall = {
            [weak self] in
            
            self?.setSelcted(index: indexPath.row)
            self?.didTapItemCall?(indexPath.row)
        }
        cell.titleLabel.text = self.dataArray[indexPath.row]
        if selectIndex == indexPath.row {
            cell.titleLabel.textColor = UIColor(red: 0.1, green: 0.09, blue: 0.09, alpha: 1)
        } else {
            cell.titleLabel.textColor = UIColor(red: 0.5, green: 0.49, blue: 0.49, alpha: 1)
        }
        return cell
    }
    
    
}
extension SHSectionBar: UICollectionViewDelegate {
    
}
