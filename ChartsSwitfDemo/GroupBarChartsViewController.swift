//
//  GroupBarChartsViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/12.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
import SnapKit
class GroupBarChartsViewController: UIViewController {

    let array = ["17655.2", "20939.38", "36271.65", "30353.48", "26874.45", "23715.13", "24367.3", "23408.85", "24016.9", "31424.75", "26744.25", "26307.8"];
    let array1 = ["17077.85", "18197.63", "29818.3", "26785.3", "26273.75", "22973.3", "23457.4", "25208.25", "27054.9", "32088.15", "24960.65", "31157.2"];
    let array2 = ["20155.2", "19874.18", "32059.85", "25786.1", "28643.8", "26407.05", "23894.45", "23832.1", "28999.18", "35795.8", "16169.15", "0.0"];
    
    var valueArray = [[String]]()
    
    
    lazy var barChart: BarChartView = {
        let view = BarChartView()
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(400)
            make.centerY.equalToSuperview()
        }
        
        
        valueArray.append(array)
        valueArray.append(array1)
        valueArray.append(array2)
        
        var dataSetMin: Double = 0
        var dataSetMax: Double = 0
        let groupSpace: Float = 0.25
        let barSpace: Float = 0.0
        let barWidth: Float = 0.25
        
        var dataSets = [BarChartDataSet]()
        for i in 0..<valueArray.count{
            var yVals = [BarChartDataEntry]()
            var set = BarChartDataSet()
            
            let array = valueArray[i]
            for j in 0..<array.count{
                let val = Double(array[j])!
                dataSetMax = max(val, dataSetMax)
                dataSetMin = min(val, dataSetMin)
                yVals.append(BarChartDataEntry.init(x: Double(j), y: val))
                set = BarChartDataSet.init(values: yVals, label: "\(i)")
                set.setColor(UIColor.green)
                set.valueColors = [UIColor.blue]
            }
            dataSets.append(set)
        }
        let diff = dataSetMax - dataSetMin
        if dataSetMax == 0 && dataSetMin == 0 {
            dataSetMin = 100.0
            dataSetMin = -10.0
        }else{
            dataSetMax = dataSetMax + diff * 0.2
            dataSetMin = dataSetMin - diff * 0.1
        }
        
        let data  = BarChartData.init(dataSets: dataSets)
        data.setValueFont(UIFont.systemFont(ofSize: 10))
        data.barWidth = Double(barWidth)
        barChart.xAxis.axisMinimum = -0.1
        barChart.xAxis.axisMaximum = 0 + data.groupWidth(groupSpace: Double(groupSpace), barSpace: Double(barSpace)) * 12
        data.groupBars(fromX: 0, groupSpace: Double(groupSpace), barSpace: Double(barSpace))
        barChart.data = data
        barChart.animate(xAxisDuration: 0.25)
    }
    
    
    
}

extension GroupBarChartsViewController: ChartViewDelegate{
    
}
