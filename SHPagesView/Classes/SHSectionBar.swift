//
//  SHSectionBar.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class SHSectionBar: UIView {
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
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        collectionView.bounces = false
        collectionView.register(SHSectionBarItemCell.self, forCellWithReuseIdentifier: "SHSectionBarItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }

    override func layoutSubviews() {
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
        }
        self.collectionView.reloadData()
    }
    
    func setSelcted(index: Int) {
        self.selectIndex = index
        self.collectionView.reloadData()
    }
    
    func scrollTo(index: Int, animated: Bool = true) {
        self.selectIndex = index
        self.collectionView.reloadData()
//        self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: animated)
    }
}

extension SHSectionBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
