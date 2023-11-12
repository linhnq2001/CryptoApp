//
//  ExchangesViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/11/2023.
//

import UIKit
import XLPagerTabStrip

class ExchangesViewController: UIViewController, IndicatorInfoProvider {
    @IBOutlet weak var tableview: UITableView!
    var data: CoinInfoResponse? {
        didSet {
            listTickets = data?.tickers ?? []
            listTickets = Array(listTickets[0..<10])
        }
    }
    var listTickets: [Ticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "ExchangeCell", bundle: nil), forCellReuseIdentifier: "ExchangeCell")
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "Exchanges")
    }
}
extension ExchangesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath) as? ExchangeCell else {
            return UITableViewCell()
        }
        cell.configData(data: listTickets[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: listTickets[indexPath.row].tradeURL ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    
}
