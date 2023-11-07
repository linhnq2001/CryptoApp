//
//  AboutViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/11/2023.
//

import UIKit
import XLPagerTabStrip

class AboutViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var tableview: UITableView!
    var data: CoinInfoResponse? {
        didSet {
            print("linhdebug \(data)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func configData(data: CoinInfoResponse) {
        
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "About")
    }

}
extension AboutViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? DescriptionCell else {
            return UITableViewCell()
        }
        cell.nameLb.text = data?.name
        cell.descriptionLb.text = data?.description?.en
        if let list = data?.categories {
            cell.categoryList.addTags(list)
        }
        return cell
    }
    
    
}
