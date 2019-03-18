//
//  TestViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/18.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
class TestViewController: UIViewController {

    //复杂结合图
    private lazy var combinedCharts: CombinedChartView = {
        let view = CombinedChartView()
        view.drawOrder = [DrawOrder.bar.rawValue,DrawOrder.line.rawValue] //绘制柱状图和折线图
        view.noDataText = "暂无数据" //没有数据时显示文本
        view.isUserInteractionEnabled = false //屏蔽view的所有手势事件
        view.legend.enabled = false //隐藏图例
        view.chartDescription?.text = "" //不显示说明设置空文本即可
        //设置x轴显示属性
        let xAxis = view.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 14)
        xAxis.labelTextColor = UIColor.black
        xAxis.valueFormatter = WeekFormatter()
        //设置左侧Y轴相关属性
        view.leftAxis.axisMinimum = 0
        view.leftAxis.enabled = false
        //设置右侧Y轴相关属性
        view.rightAxis.enabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(combinedCharts)
        combinedCharts.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
//        weekCharts.updateCombinedCharts(data: [9,8,7,6,5,4,3,2,1,0,1,4,7,9])
        self.updateCombinedCharts(data: [9,8,7,6,5,4,3,2,1,0,1,4,7,9])
    }
    

    /// 更新合并图表的数据
    ///
    /// - Parameter data: 填充数据
    func updateCombinedCharts(data: [Int]){
        let chartData = CombinedChartData()
        chartData.barData = self.updateCombinedBarChart(data: data)
        chartData.lineData = self.updateCombinedLineChart(data: data)
        combinedCharts.data = chartData
        combinedCharts.notifyDataSetChanged() //通知数据改变
    }
    
    /// 更新合并图标柱状图的界面
    ///
    /// - Parameter data: 填充数据
    private func updateCombinedBarChart(data: [Int])->BarChartData{
        var entries = [BarChartDataEntry]()
        for i in 0..<data.count {
            let entry = BarChartDataEntry.init(x: Double(i), y: Double(data[i]))
            entries.append(entry)
        }
        let set = BarChartDataSet.init(values: entries, label: "")
        set.setColor(UIColor.red) //设置柱状图填充颜色
        set.drawValuesEnabled = false //是否显示数值
        let data = BarChartData.init(dataSets: [set])
        data.barWidth = 0.9
        return data
    }
    
    /// 更新合并图折线图的界面
    ///
    /// - Parameter data: 填充数据
    private func updateCombinedLineChart(data: [Int])->LineChartData{
        var entries = [ChartDataEntry]()
        for i in 0..<data.count {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(data[i]))
            entries.append(entry)
        }
        let dataSet = LineChartDataSet.init(values: entries, label: "")
        dataSet.setColor(UIColor.red) //设置折线颜色
        dataSet.drawValuesEnabled = false //不显示数据
        dataSet.mode = .cubicBezier //折线类型
        dataSet.drawFilledEnabled = false //是否显示折线图阴影
        return LineChartData.init(dataSets: [dataSet])
    }
}

/// 周类型IAxis轴字符
class WeekFormatter: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "周\(Int(value))"
    }
}
