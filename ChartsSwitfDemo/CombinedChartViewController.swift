//
//  CombinedChartViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/13.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
class CombinedChartViewController: UIViewController {

    lazy var combinedChart: CombinedChartView = {
        let view = CombinedChartView()
        self.view.addSubview(view)
        view.drawOrder = [DrawOrder.bar.rawValue,DrawOrder.line.rawValue] //绘制图标类型柱状图和折线图折线图在柱状图上面
        view.noDataText = "暂无数据" //无数据时显示的文字
        view.chartDescription?.text = "" //描述文字为空就不显示说明
        view.legend.enabled = false //隐藏图例
        view.pinchZoomEnabled = false //禁用触控放大
        view.doubleTapToZoomEnabled = false //禁用双击放大
        view.scaleXEnabled = false //禁用X轴缩放
        view.scaleYEnabled = false //禁用Y轴缩放
        view.highlightPerTapEnabled = false //禁用单击高亮
        view.highlightPerDragEnabled = false //禁用拖拽高亮
        view.dragEnabled = true //拖拽图标
        view.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        view.dragDecelerationFrictionCoef = 0.5 //拖拽后惯性效果摩擦系数（0~1），数值越小，惯性越不明显
        //设置左侧Y轴显示的值的属性
        let leftAxis = view.leftAxis
        leftAxis.labelPosition = .outsideChart //标签显示位置
        leftAxis.drawGridLinesEnabled = true //网格绘制
        leftAxis.gridColor = UIColor.lightGray //网格颜色
        leftAxis.gridLineWidth = 0.5 //网格线宽
        leftAxis.drawAxisLineEnabled = false //是否显示轴线
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10) //标签字号
        leftAxis.labelTextColor = UIColor.lightGray //标签颜色
        leftAxis.axisMinimum = 0 //最小值
        leftAxis.axisMaximum = 300 //最大值
        leftAxis.labelCount = 10 //设置标签个数 最少两个 最多25个默认6个
        //设置右侧Y轴显示的值属性
        let rightAxis = view.rightAxis
        rightAxis.labelPosition = .outsideChart //标签显示位置
        rightAxis.drawAxisLineEnabled = false //是否显示轴线
        rightAxis.drawGridLinesEnabled = false //网格绘制
        rightAxis.labelFont = UIFont.systemFont(ofSize: 10) //标签字号
        rightAxis.labelTextColor = UIColor.lightGray
        rightAxis.axisMinimum = 0 //最小值
        rightAxis.axisMaximum = 300 //最大值
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CombinedChartView"
        deploySubviews()
    }
    
    private func deploySubviews(){
        combinedChart.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(350)
            make.center.equalToSuperview()
        }
        
        setCombinedData(11, [10,5,25,55,15,95,90,75,99,10,55], [10,5,25,55,15,95,90,75,99,10,55], [20,10,50,110,30,190,180,160,198,20,110])
    }
    
    /// 柱状图数据
    ///
    /// - Parameters:
    ///   - bar1Values: 第一段的数据
    ///   - bar2Values: 第二段的数据
    /// - Returns: 柱状图的数据
    private func getBarData(bar1Values: [Double],bar2Values: [Double])->BarChartData{
        var barEntries = [BarChartDataEntry]()
        if bar1Values.count == bar2Values.count {
            for i in 0..<bar1Values.count{
                let barEntry = BarChartDataEntry.init(x: Double(i), yValues: [bar1Values[i],bar2Values[i]])
                barEntries.append(barEntry)
            }
        }
        
        let dataSet = BarChartDataSet.init(values: barEntries, label: "")
        dataSet.colors = [UIColor.green,UIColor.blue]
        dataSet.axisDependency = .left //根据左边数据显示
        dataSet.drawValuesEnabled = false //是否显示数据
        let data = BarChartData.init(dataSets: [dataSet])
        data.barWidth = 0.7 //柱状图宽度（范围0~1）为1时柱状图将连接在一起
        return data
    }

    
    /// 获取折线图数据
    ///
    /// - Parameter data: 传入数
    /// - Returns: 返回折线图填充数据
    private func getLine(_ data:[Double])->LineChartData{
        var entries = [ChartDataEntry]()
        for i in 0..<data.count {
            let entry = ChartDataEntry.init(x: Double(i), y: data[i])
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet.init(values: entries, label: "")
        dataSet.colors = [UIColor.orange] //折线的颜色
        dataSet.lineWidth = 0.5 //线宽
        dataSet.circleRadius = 2.5 //圆点半径
        dataSet.circleHoleRadius = 1.5 //圆点内圆半径
        dataSet.circleColors = [UIColor.orange] //圆点外圆的颜色
        dataSet.circleHoleColor = UIColor.white //圆点内圆的颜色
        dataSet.axisDependency = .right //根据→_→数据显示
        dataSet.drawIconsEnabled = false //是否显示数据
        dataSet.mode = .cubicBezier //折线图类型
        dataSet.drawFilledEnabled = true //是否显示折线图阴影
        let shadowColors = [UIColor.orange.withAlphaComponent(0.0).cgColor,UIColor.orange.withAlphaComponent(0.7).cgColor] as CFArray
        let gradient = CGGradient.init(colorsSpace: nil, colors: shadowColors, locations: nil)!
        dataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        //阴影渐变效果
        dataSet.fillAlpha = 1.0 //阴影透明度
        let lineData = LineChartData.init(dataSets: [dataSet])
        return lineData
    }

    
    private func setCombinedData(_ xValues:Int
        ,_ bar1Values:[Double]
        ,_ bar2Values:[Double]
        ,_ lineValues:[Double]){
        let data = CombinedChartData()
        data.barData = getBarData(bar1Values: bar1Values, bar2Values: bar2Values) //柱状图数据
        data.lineData = getLine(lineValues) //主线图数据
        combinedChart.data = data //图标数据
        
        let xAxis = combinedChart.xAxis
        xAxis.axisMinimum = data.xMin - 0.25 //X轴最小数据量
        xAxis.axisMaximum = data.xMax + 0.25 //X轴最大数量
        xAxis.valueFormatter = CombinedChartFormatter()
        xAxis.labelPosition = .bottom
        xAxis.labelCount = xValues
//        combinedChart.setVisibleXRangeMaximum(7) //X轴最多显示数量
        combinedChart.animate(yAxisDuration: 0.5) //添加Y轴动画
        combinedChart.notifyDataSetChanged() //通知数据改变
    }
    
}

class CombinedChartFormatter: IAxisValueFormatter{
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        print("========\(value)")
        return "\(Int(value))月"
    }
}
