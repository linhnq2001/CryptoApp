//
//  PortfolioViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxSwift

class PortfolioViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private(set) var viewModel: PortfolioViewModel!
    @IBOutlet weak var collectionview: UICollectionView!
    
    init(viewModel: PortfolioViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PortfolioViewController.self), bundle: Bundle(for: PortfolioViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapAllPortfolio(_ sender: Any) {
        let vc = ChooseAssetVC(viewModel: ChooseAssetViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
