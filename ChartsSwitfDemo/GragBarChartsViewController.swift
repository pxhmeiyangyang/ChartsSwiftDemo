//
//  GragBarChartsViewController.swift
//  ChartsSwitfDemo
//
//  Created by pxh on 2019/3/12.
//  Copyright © 2019 pxh. All rights reserved.
//

import UIKit
import Charts
class GragBarChartsViewController: UIViewController {

    lazy var barChartView: BarChartView = {
        let view  = BarChartView()
        view.delegate = self
        self.view.addSubview(view)
        return view
    }()
    
    lazy var data = BarChartData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add barChartView
        deploySubviews()
        
        barChartView.backgroundColor = UIColor.init(red: 230/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        barChartView.noDataText = "暂无数据" //没有数据是的文字提示
        barChartView.drawValueAboveBarEnabled = true //数值显示在柱形的上面还是下面
        barChartView.drawBarShadowEnabled = false //是否绘制柱形的阴影背景
        //交互设置
        barChartView.scaleYEnabled = false //取消Y轴缩放
        barChartView.doubleTapToZoomEnabled = false //取消双击缩放
        barChartView.dragEnabled = true //启用拖拽图表
        barChartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        barChartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        //x轴样式
        let xAxis = barChartView.xAxis
        xAxis.axisLineWidth = 1.0 //设置x轴线宽
        xAxis.labelPosition = .bottom //X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false //不绘制网格线
        xAxis.labelWidth = 10 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        xAxis.labelTextColor = UIColor.red //设置label的文字颜色
        
//        xAxis.labelCount = 5
        //右边Y轴d样式
        barChartView.rightAxis.enabled = false
        //左边Y轴样式
        let leftAxis = barChartView.leftAxis //获取左边Y轴
        leftAxis.labelCount = 5 //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = false //不强制绘制定数的label
        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true //从0开始绘制
        leftAxis.axisMaximum = 105 //设置Y轴的最大值
        leftAxis.inverted = false //是否将Y轴上线翻转
        leftAxis.axisLineWidth = 0.5 //Y轴线宽
        leftAxis.axisLineColor = UIColor.gray //Y轴颜色
//        leftAxis.valueFormatter = NumberFormatter.init() //自定义格式
        leftAxis.labelPosition = .outsideChart //label位置
        leftAxis.labelTextColor = UIColor.brown //文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10.0) //字体大小
        //网格线样式
        leftAxis.gridLineDashLengths = [3.0,3.0]
        leftAxis.gridColor = UIColor.black
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
        //添加限制线
        let limitLine = ChartLimitLine.init(limit: 80, label: "限制线")
        limitLine.lineWidth = 2
        limitLine.lineColor = UIColor.green
        limitLine.lineDashLengths = [5.0,5.0] //虚线样式
        limitLine.labelPosition = .rightTop //位置
        leftAxis.addLimitLine(limitLine) //添加到Y轴上
        leftAxis.drawLimitLinesBehindDataEnabled = true //设置限制线绘制在柱形图的后面
        
        //图例说明样式
        barChartView.legend.enabled = false //不显示图例说明
        barChartView.legend.direction = .leftToRight //显示方向
        //右下角description文字样式
        barChartView.chartDescription?.text = "" //不显示设置为空字符串即可
        
        self.updateData()
        
        
    }
    
    /// 设置显示数据
    ///
    /// - Returns: BarChartData
    private func setData()->BarChartData{
        let xVals_count = 12 //X轴上要显示多少条数据
        let maxYVal: Double = 100 //Y轴的最大值
        //X轴上面需要显示的数据
        var xVals = [String]()
        for i in 0..<xVals_count {
            xVals.append("\(i)月")
        }
        barChartView.xAxis.labelCount = xVals_count
        barChartView.xAxis.valueFormatter = BarChartFormatter.init()
        //对应Y轴上面x要显示的数据
        var yVals = [BarChartDataEntry]()
        for i in 0..<xVals_count {
            let mult = UInt32(maxYVal + 1.0)
            let val = Double(arc4random_uniform(mult))
            let entry = BarChartDataEntry.init(x: Double(i), y: val)
            yVals.append(entry)
        }
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        let set1 = BarChartDataSet.init(values: yVals, label: "nil")
        set1.barBorderWidth = 0.2 //柱形之间的间隙占整个柱形(柱形+间隙)的比例
        set1.drawValuesEnabled = true //是否在柱状图上显示数值
        set1.highlightEnabled = false //点击选中柱状图是否显示高亮效果
        set1.setColors(ChartColorTemplates.material(), alpha: 1.0)//设置柱状图的颜色
        //将BarChartDataSet 对象放入数组中
        var dataSets = [BarChartDataSet]()
        dataSets.append(set1)
        
        //创建BarChartData对象，此对象就是barChartView需要最终数据对象
        let data = BarChartData.init(dataSets: dataSets)
        data.setValueFont(UIFont.init(name: "HelveticaNeue-Light", size: 10.0))//文字w字体
        data.setValueTextColor(UIColor.orange)
        return data
    }
    
    
    private func updateData(){
        barChartView.data = self.setData()
        barChartView.notifyDataSetChanged()
        barChartView.animate(yAxisDuration: 0.8)
    }
    
    private func deploySubviews(){
        barChartView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.frame.width - 20)
            make.height.equalTo(300)
        }
    }
    

    

}

extension GragBarChartsViewController: ChartViewDelegate{
    
}

class BarChartFormatter:IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))月"
    }
}
