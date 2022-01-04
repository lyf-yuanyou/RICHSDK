//
//  DiscountViewController.swift
//  richsdkdemo
//
//  Created by 11号 on 2021/3/10.
//

import UIKit
import RICHSDK

class DiscountViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var tableView: UITableView!;
    
    override func viewDidLoad() {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.addHeaderRefresh(block: {
            self.requestForData()
        }, style: .spinFade)
            
        tableView.addFooterRefresh {
            self.requestMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Row-\(indexPath.row)"
        return cell
    }
    
    func requestForData() {
        print("下拉刷新")
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.tableView.endHeaderRefresh()
        }
    }
    
    func requestMoreData(){
        print("加载更多数据")
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.tableView.endFooterRefresh()
        }
    }
}

