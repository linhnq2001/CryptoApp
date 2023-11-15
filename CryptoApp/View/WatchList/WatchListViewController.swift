//
//  WatchListViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxRelay

class WatchListViewController: UIViewController {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableview: UITableView!{
        didSet {
            tableview.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinInfoTableViewCell")
        }
    }
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,CoinInfoResponse>> { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "CoinInfoTableViewCell", for: indexPath) as? CoinInfoTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    private(set) var viewModel: WatchListViewModel!
    private let trigger = PublishSubject<Void>()
    private let tapToWatchList = PublishRelay<CoinInfoResponse>()
    private var disposeBag = DisposeBag()
    private var listData: [CoinInfoResponse] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: WatchListViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: WatchListViewController.self), bundle: Bundle(for: WatchListViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
    }
    
    private func bindingData() {
        let input = WatchListViewModel.Input(trigger: trigger, tapToWatchList: tapToWatchList)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleBindingTableView(output)
        trigger.onNext(())
        searchBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let vc = SearchViewController(viewModel: SearchViewModel())
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func handleLoading(_ output: WatchListViewModel.Output) {
        output.showLoading.subscribe(onNext: { isLoading in
            
        }).disposed(by: disposeBag)
    }
    
    private func handleBindingTableView(_ output: WatchListViewModel.Output) {
        output.watchList.flatMap { [weak self] listData -> Observable<[SectionModel<String, CoinInfoResponse>]> in
            guard let self = self else {
                return .empty()
            }
            self.listData = listData
            return Observable.just([SectionModel(model: "", items: listData)])
        }.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

}
