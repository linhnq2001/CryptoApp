//
//  OverviewViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/11/2023.
//

import UIKit
import XLPagerTabStrip
import RxDataSources

class OverviewViewController: UIViewController, IndicatorInfoProvider {
    var data: CoinInfoResponse? {
        didSet {
            tableview.reloadData()
        }
    }

    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
            tableview.register(UINib(nibName: "ChartCell", bundle: nil), forCellReuseIdentifier: "ChartCell")
            tableview.register(UINib(nibName: "MarketStatisticsCell", bundle: nil), forCellReuseIdentifier: "MarketStatisticsCell")
            tableview.register(UINib(nibName: "ExchangesCell", bundle: nil), forCellReuseIdentifier: "ExchangesCell")
            tableview.register(UINib(nibName: "AboutAssetCell", bundle: nil), forCellReuseIdentifier: "AboutAssetCell")
            tableview.register(UINib(nibName: "TrendingAssetsCell", bundle: nil), forCellReuseIdentifier: "TrendingAssetsCell")
            tableview.register(UINib(nibName: "MarketPriceCell", bundle: nil), forCellReuseIdentifier: "MarketPriceCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "Overview")
    }

}

extension OverviewViewController: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 0 : 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "MarketPriceCell", for: indexPath) as? MarketPriceCell,
              let cell2 = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell,
              let cell3 = tableView.dequeueReusableCell(withIdentifier: "MarketStatisticsCell", for: indexPath) as? MarketStatisticsCell,
              let cell4 = tableView.dequeueReusableCell(withIdentifier: "ExchangesCell", for: indexPath) as? ExchangesCell,
              let cell5 = tableView.dequeueReusableCell(withIdentifier: "AboutAssetCell", for: indexPath) as? AboutAssetCell,
              let cell6 = tableView.dequeueReusableCell(withIdentifier: "TrendingAssetsCell", for: indexPath) as? TrendingAssetsCell,
              let data = data
        else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell1.configData(data: data)
            return cell1
        case 1:
            return cell2
        case 2:
            cell3.didTapSeeAll = { [weak self] in
                guard let self = self else { return }
                let vc = MarketStatisticsVC(data: data)
                self.present(vc, animated: true)
            }
            cell3.configData(data: data)
            return cell3
        case 3:
            return cell4
        case 4:
            cell5.configData(data: data)
            return cell5
        case 5:
            return cell6
        default:
            return UITableViewCell()
        }
    }

}
