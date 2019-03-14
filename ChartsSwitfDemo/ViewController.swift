//
//  ViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/11.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit

import SnapKit
class ViewController: UIViewController {
    
    
    private let tableDatas = ["Group bar charts","Bar charts","Line charts","Drag Bar Charts","Combined Chart"]
    
    lazy var tableview: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.tableFooterView = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Charts"
        
        tableview.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = tableDatas[indexPath.row]
        var viewController: UIViewController!
        switch title {
        case "Group bar charts":
            viewController = GroupBarChartsViewController()
            viewController.title = title
            break
        case "Bar charts":
            viewController = BarChartsViewController()
            viewController.title = title
            break
        case "Line charts":
            break
        case "Combined Chart":
            viewController = CombinedChartViewController()
            viewController.title = title
            break
        case "Drag Bar Charts":
            viewController = GragBarChartsViewController()
            viewController.title = title
            break
        default:
            break
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = tableDatas[indexPath.row]
        return cell!
    }
    
}

