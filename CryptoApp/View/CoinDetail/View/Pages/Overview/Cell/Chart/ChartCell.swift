//
//  ChartCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit
import Charts

class ChartCell: UITableViewCell, ChartViewDelegate {
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .outsideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 12)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .systemBlue
        chartView.animate(xAxisDuration: 2.5)
        return chartView
    }()
    
    var data: CoinInfoResponse? {
        didSet {
            setupChartData()
        }
    }

    @IBOutlet private weak var containerView: UIView!

    private func setupChartData() {
        lineChartView.backgroundColor = UIColor.systemBlue
        lineChartView.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 240)
        containerView.addSubview(lineChartView)
        var chartData: [ChartDataEntry] = []
        if let priceData = data?.marketData?.sparkline7D?.price?.suffix(24) {
            chartData = priceData.enumerated().map({ (index, price) in
                return ChartDataEntry(x: Double(index), y: price)
            })
        }
        let lineChartDataSet = LineChartDataSet(entries: chartData, label: "Price")
        
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.drawCirclesEnabled = false
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartData.setDrawValues(false)
        lineChartView.data = lineChartData
    }
    
    func configData(data: CoinInfoResponse) {
        self.data = data
    }
}
