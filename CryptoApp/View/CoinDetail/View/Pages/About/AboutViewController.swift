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
            if let data = data {
                linkData = filterData(data: data)
            }
        }
    }
    
    var linkData: [LinkData] = [] {
        didSet {
            if !linkData.isEmpty {
                tableview?.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tableview.register(UINib(nibName: "LinkCoinCell", bundle: nil), forCellReuseIdentifier: "LinkCoinCell")
        tableview.delegate = self
        tableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func configData(data: CoinInfoResponse) {
        
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        return IndicatorInfo(title: "About")
    }
    
    private func filterData(data: CoinInfoResponse) -> [LinkData] {
        var result: [LinkData] = []
        if let link = data.links {
            if let homepage = link.homepage?.filter({!$0.isEmpty}), !homepage.isEmpty {
                result.append(LinkData(title: "Home Page", links: homepage))
            }
            if let blockchain_site = link.blockchainSite?.filter({!$0.isEmpty}), !blockchain_site.isEmpty {
                result.append(LinkData(title: "Blockchain Site", links: blockchain_site))
            }
            if let twitterLink = link.twitterScreenName {
                result.append(LinkData(title: "Twitter", links: ["https://twitter.com/\(twitterLink)"]))
            }
            var otherLinks: [String] = []
            if let chatsLink = link.chatURL?.filter({!$0.isEmpty}) {
                otherLinks.append(contentsOf: chatsLink)
            }
            if let anoumentLink = link.announcementURL?.filter({!$0.isEmpty}) {
                otherLinks.append(contentsOf: anoumentLink)
            }
            if !otherLinks.isEmpty {
                result.append(LinkData(title: "Others", links: otherLinks))
            }
        }
        return result
    }

}
extension AboutViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + linkData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? DescriptionCell,
              let linkCell = tableView.dequeueReusableCell(withIdentifier: "LinkCoinCell", for: indexPath) as? LinkCoinCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 {
            descriptionCell.configData(data: data)
            return descriptionCell
        } else {
            linkCell.configData(data: linkData[indexPath.row - 1])
            return linkCell
        }
    }
}

public struct LinkData{
    var title: String
    var links: [String]
}
