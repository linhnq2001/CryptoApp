//
//  AnalyticsVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 20/11/2023.
//

import UIKit
import Charts

class AnalyticsVC: UIViewController, ChartViewDelegate {
    private(set) var portfolio: Portfolio
    @IBOutlet private weak var portfolioView: UIView! {
        didSet {
            portfolioView.addShadow()
        }
    }
    @IBOutlet private weak var timeframeView: TimeFrameView!
    @IBOutlet private weak var totalValueLb: UILabel!
    @IBOutlet private weak var percentChangeLb: UILabel!
    @IBOutlet private weak var percentChangeView: UIView!
    @IBOutlet private weak var totalProfitLb: UILabel!
    @IBOutlet private weak var percentProfitLb: UILabel!
    @IBOutlet private weak var realizedProfitView: UIView!
    @IBOutlet private weak var realizedProfitLb: UILabel!
    @IBOutlet private weak var totalInvestedLb: UILabel!
    @IBOutlet private weak var unrealizedProfitLb: UILabel!
    
    @IBOutlet private weak var chartView: UIView!
    private var pieChart = PieChartView()
    
    init(portfolio: Portfolio) {
        self.portfolio = portfolio
        super.init(nibName: String(describing: AnalyticsVC.self), bundle: Bundle(for: AnalyticsVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChart()
        // Do any additional setup after loading the view.
    }
    
    private func setupChart() {
        pieChart.delegate = self
        pieChart.frame = CGRect(x: 0, y: 0, width: chartView.frame.size.width, height: chartView.frame.size.height)
        chartView.addSubview(pieChart)
        chartView.addShadow()
        chartView.layer.cornerRadius = 10
        
        let values = portfolio.listToken.map { tokenInPort in
            return PieChartDataEntry(value: tokenInPort.getValue(), label: tokenInPort.symbol.uppercased())
        }
        // Tạo dataset
        let dataSet = PieChartDataSet(entries: values, label: "")
        
        // Thêm màu cho từng phần
        dataSet.colors = ChartColorTemplates.material()
        
        // Tạo dữ liệu cho biểu đồ
        let data = PieChartData(dataSet: dataSet)
        
        // Hiển thị dữ liệu trên biểu đồ
        pieChart.data = data
        
        // Tùy chỉnh các thuộc tính khác của biểu đồ nếu cần
//        pieChart.chartDescription.text = "Pie Chart Example"
        pieChart.drawHoleEnabled = false
    }
    
    private func setupUI() {
        self.totalValueLb.text = "$ \(portfolio.getValue())"
        let totalProfit = portfolio.getTotalProfit()
        let totalInvested = round(portfolio.getTotalInvested() * 100) / 100
        let percentProfit = round(totalProfit / totalInvested * 100 * 100) / 100
        self.totalProfitLb.text = "$ \(totalProfit)"
        self.percentProfitLb.text = "\(percentProfit) %"
        if let realizedProfit = portfolio.getRealizedProfit() {
            self.realizedProfitView.isHidden = false
            self.realizedProfitLb.text = "$ \(realizedProfit)"
        } else {
            self.realizedProfitView.isHidden = true
        }
        let unrealizedProfit = round(portfolio.getUnrealizedProfit() * 100) / 100
        self.unrealizedProfitLb.text = "$ \(unrealizedProfit)"
        self.totalInvestedLb.text = "$ \(totalInvested)"
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func formatNumber(number: Double) -> String {
        let knumber = round(number/1000.0 * 100) / 100.0
        let mnumber = round(number/1000000.0 * 100) / 100.0
        let bnumber = round(number/1_000_000_000.0 * 100) / 100.0
        if bnumber >= 1 {
            return "\(bnumber) B"
        } else if mnumber >= 1 {
            return "\(mnumber) M"
        } else if knumber >= 1 {
            return "\(knumber) K"
        } else {
            return "\(number)"
        }
    }

}
