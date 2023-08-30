//
//  ChildListViewController.swift
//  SHPagesView_Example
//
//  Created by Ray on 2023/8/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//
import SHPagesView
import MJRefresh
import UIKit

class ChildListViewController: UIViewController, UITableViewDataSource,SHPageChildUIViewContoller {
    func shGetAllInteractScrollView() -> [UIScrollView] {
        return [self.tableView]
    }
    
    
    

    var dataArray: [String] = []
    
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalTo(0)
        }
        for item in 0...20 {
            self.dataArray.append("\(item)")
        }
        tableView.dataSource = self
        
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
        
        tableView.delegate = self
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem.init(block: {
                [weak self] in
                self?.tableView.mj_footer?.endRefreshing()
                for item in 0...20 {
                    self?.dataArray.append("\(item)")
                }
                self?.tableView.reloadData()
            }))
        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
        let item = self.dataArray[indexPath.row]
        cell.textLabel?.text = item
        cell.backgroundColor = .brown
        cell.tapCall = {
            [weak self] in
            let toVC = ChildListViewController.init()
            
            self?.navigationController?.pushViewController(toVC, animated: true)
        }
        return cell
    }
}

extension ChildListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let toVC = ChildListViewController.init()
//        
//        self.navigationController?.pushViewController(toVC, animated: true)
    }
}
