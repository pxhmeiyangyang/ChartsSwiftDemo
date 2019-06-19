//
//  UniToy3BarChatVC.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/6/18.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
class UniToy3BarChatVC: UIViewController {

    lazy var barChartView: BarChartView = {
        let view = BarChartView()
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deploy subviews
        barChartView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width - 20)
            make.height.equalTo(300)
        }
        
        barChartView.backgroundColor = UIColor.init(red: 230/255, green: 253/255, blue: 253/255, alpha: 1)
        barChartView.noDataText = "暂无数据" //没有数据的文字提示
        barChartView.drawValueAboveBarEnabled = true   //数值显示在柱状图上面还是下面
        barChartView.drawBarShadowEnabled = false //是否绘制柱状图阴影
        //交互设置
        barChartView.scaleXEnabled = false //取消Y轴缩放
        barChartView.doubleTapToZoomEnabled = false //取消双击缩放
        barChartView.dragEnabled = false //取消拖拽图标
        barChartView.dragDecelerationEnabled = false //取消拖拽惯性效果
        //x轴样式
        let xAxis = barChartView.xAxis
        xAxis.axisLineWidth = 1.0 //设置x轴线宽
        xAxis.labelPosition = .bottom //x轴标签显示位置，默认在顶部
        xAxis.drawGridLinesEnabled = false //不绘制网格线
        xAxis.labelTextColor = UIColor.red //设置label的颜色
        xAxis.labelCount = 24
//        xAxis.setLabelCount(5, force: true)
        xAxis.valueFormatter = UTBarChartFormatter.init()
        //右侧Y轴样式
        barChartView.rightAxis.enabled = false
        //左侧y轴的样式
        let leftAxis = barChartView.leftAxis //获取左边Y轴
        leftAxis.labelCount = 5 //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = false //不强制绘制定数的label
        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true //从零开始设置
        leftAxis.axisMaximum = 105 //设置Y轴最大值
        leftAxis.inverted = false //是否将y轴上线翻转
        leftAxis.axisLineWidth = 0.5 //设置y轴线宽
        leftAxis.axisLineColor = UIColor.gray //Y轴颜色
        leftAxis.labelPosition = .outsideChart //label 位置
        leftAxis.labelTextColor = UIColor.brown  //文字颜色
        //网格线样式
        leftAxis.gridLineDashLengths = [3.0,3.0]
        leftAxis.gridColor = UIColor.black
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
        //图例说明样式
        barChartView.legend.enabled = false //不显示图例说明
        barChartView.legend.direction = .leftToRight //显示方向
        barChartView.chartDescription?.text = "" //不显示设置为空字符即可
        barChartView.data = self.setData()
        barChartView.notifyDataSetChanged()
        barChartView.animate(yAxisDuration: 0.8)
    }

    /// 设置显示时间
    ///
    /// - Returns: 柱状图显示的数据
    private func setData()->BarChartData{
        let xVals_count = 24 //X轴上要显示多少条数据
        let maxYVal: Double = 100 //设置Y轴最大值
        //对应Y轴要显示的数据
        var yVals = [BarChartDataEntry]()
        for i in 0..<xVals_count {
            let mult = UInt32(maxYVal + 1.0)
            let val = Double(arc4random_uniform(mult))
            let entry = BarChartDataEntry.init(x: Double(i), y: val)
            yVals.append(entry)
        }
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        let set = BarChartDataSet.init(values: yVals, label: "nil")
        set.barBorderWidth = 0.2 //柱子之间的间隙占整个柱形的比例（柱形+间隙）
        set.setColors(ChartColorTemplates.material(), alpha: 1.0) //设置柱子的颜色
        //将BarChartDataSet 对象放入数组中
        var dataSets = [BarChartDataSet]()
        dataSets.append(set)
        let data = BarChartData.init(dataSets: dataSets)
        data.setValueTextColor(UIColor.orange)
        return data
    }
    
}

extension UniToy3BarChatVC: ChartViewDelegate{
    
}

class UTBarChartFormatter:IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let intValue = Int(value)
        print(intValue)
        if intValue == 0 || intValue == 6 || intValue == 12 || intValue == 18 {
            return "0" + "\(Int(value))时"
        }
        return ""
    }
}
