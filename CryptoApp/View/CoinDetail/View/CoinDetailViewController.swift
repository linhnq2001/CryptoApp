//
//  CoinDetailViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 18/10/2023.
//

import UIKit
import RxSwift
import XLPagerTabStrip

class CoinDetailViewController: ButtonBarPagerTabStripViewController {
    
    let disposeBag = DisposeBag()
    let trigger = PublishSubject<Void>()
    var coinInfo: CoinInfoResponse? {
        didSet {
            about.data = coinInfo
            exchanges.data = coinInfo
        }
    }
    private(set) var viewModel: CoinDetailViewModel!
    let overview = OverviewViewController()
    let exchanges = ExchangesViewController()
    let about = AboutViewController()

    init(viewModel: CoinDetailViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: CoinDetailViewController.self), bundle: Bundle(for: CoinDetailViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        configureButtonBar()
    }
    
    private func bindingData() {
        let input = CoinDetailViewModel.Input(trigger: trigger)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleUpdateData(output)
        trigger.onNext(())
    }

    private func handleLoading(_ output: CoinDetailViewModel.Output) {
        output.showLoading.subscribe(onNext: {isLoading in
            
        }).disposed(by: disposeBag)
    }

    private func handleUpdateData(_ output: CoinDetailViewModel.Output) {
        output.infoCoin.subscribe(onNext: { [weak self] coinInfo in
            guard let self = self else { return }
            self.coinInfo = coinInfo
        }).disposed(by: disposeBag)
    }
    // MARK: - Configuration
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white

        settings.style.buttonBarItemFont = UIFont(name: "Helvetica", size: 16.0)!
        settings.style.buttonBarItemTitleColor = .gray
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        settings.style.selectedBarHeight = 1.0
        settings.style.selectedBarBackgroundColor = .black
        
        // Changing item text color on swipe
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = .black
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [overview, exchanges, about]
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
