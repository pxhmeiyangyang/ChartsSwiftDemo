//
//  BarChartsViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/12.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
class BarChartsViewController: UIViewController {

    lazy var barCharts: BarChartView  = {
        let view = BarChartView()
        self.view.addSubview(view)
        view.delegate = self
        view.backgroundColor = UIColor.gray
        
        //屏蔽介绍label
        //                barCharts.chartDescription?.enabled = false
        //        barCharts.maxVisibleCount = 60
        //        barCharts.pinchZoomEnabled = false
        //        barCharts.drawBarShadowEnabled = false
        //禁用所有用户手势
        view.isUserInteractionEnabled = false
        //隐藏所有背景表格
        view.xAxis.enabled = false
        view.leftAxis.enabled = false
        view.rightAxis.enabled = false
        //屏蔽介绍label
        //        view.legend.enabled = false
        return view
    }()
    
    private let datas = ["00时","06时","12时","18时"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //页面布局
        barCharts.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let data = BarChartData.init()
        var sets = [BarChartDataSet]()
        for i in 0..<datas.count{
            var title = datas[i]
            var valus = [BarChartDataEntry]()
            var set = BarChartDataSet.init()
            for i in 0...5 {
                //赋值
                var temp = Double(i)
                if i == 0{
                    temp = 0.1
                }
                valus.append(BarChartDataEntry.init(x: Double(i), y: Double(temp * 20)))
                set = BarChartDataSet.init(values: valus, label: title)
                set.colors = [UIColor.green]
                //屏蔽数值
                set.drawValuesEnabled = false
            }
            
            sets.append(set)
        }
        data.dataSets = sets
        
        //柱状图的宽度
        data.barWidth = 0.5
        data.groupBars(fromX: 0, groupSpace: 0, barSpace: 0.5)
        barCharts.data = data
        barCharts.fitBars = true
    }
    
}

extension BarChartsViewController: ChartViewDelegate{
    
}
