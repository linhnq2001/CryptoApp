//
//  TimeFrameView.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 02/11/2023.
//

import UIKit
@IBDesignable
final class TimeFrameView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionview: UICollectionView!{
        didSet {
            collectionview.delegate = self
            collectionview.dataSource = self
            collectionview.register(UINib(nibName: "TimeFrameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimeFrameCollectionViewCell")
        }
    }
    private var listTimeFrame = ["1H","24H","7D","1M","3M","6M","1Y"]
    private var selectedTimeFrame = "24H"
    var didChangeTimeFrame: ((_ timeFrame: String) ->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        guard let view = self.loadViewFromNib(nibName: "TimeFrameView") else {return}
        view.frame = self.bounds
        addSubview(view)
    }
}
extension TimeFrameView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.bounds.width / CGFloat(self.listTimeFrame.count)) - 20
        return CGSize(width: (self.bounds.width / CGFloat(self.listTimeFrame.count)) - 5, height: self.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTimeFrame.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeFrameCollectionViewCell", for: indexPath) as? TimeFrameCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configData(timeFrame: listTimeFrame[indexPath.row], isSelected: listTimeFrame[indexPath.row] == selectedTimeFrame)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTimeFrame = listTimeFrame[indexPath.row]
        self.didChangeTimeFrame?(listTimeFrame[indexPath.row])
        collectionView.reloadData()
    }
}
