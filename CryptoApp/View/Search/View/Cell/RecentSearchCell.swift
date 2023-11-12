//
//  RecentSearchCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 09/11/2023.
//

import UIKit

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var collectionview: UICollectionView!
    var recentSearch: [CoinInfoResponse] = []
    var didTapClearRecentSearch: (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "RecentSearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentSearchCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configData(data: SearchDataSource) {
        guard let data = data as? RecentSearchDataSource else {
            return
        }
        self.recentSearch = data.listItem
        collectionview.reloadData()
    }

    @IBAction func didTapClearRecentSearch(_ sender: Any) {
        self.didTapClearRecentSearch?()
    }
}
extension RecentSearchCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchCollectionViewCell", for: indexPath) as? RecentSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configData(data: recentSearch[indexPath.row])
        return cell
    }
    
}
