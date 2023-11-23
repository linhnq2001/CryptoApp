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
            tableview.rx.setDelegate(self).disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var emptyView: UIView!
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,CoinInfoResponse>> { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "CoinInfoTableViewCell", for: indexPath) as? CoinInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.configData(data: item)
        return cell
    }
    private(set) var viewModel: WatchListViewModel!
    private let trigger = PublishSubject<Void>()
    private let tapToWatchList = PublishRelay<CoinInfoResponse>()
    private let removeFromWatchList = PublishRelay<String>()
    private var disposeBag = DisposeBag()
    private var listData: [CoinInfoResponse] = []
    private var firstAppear: Bool = true

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger.onNext(())
    }
    
    private func bindingData() {
        let input = WatchListViewModel.Input(trigger: trigger, tapToWatchList: tapToWatchList, removeFromWatchlist: removeFromWatchList)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleBindingTableView(output)
        handleRemoveFromWatchlist(output)
        trigger.onNext(())
        searchBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            let vc = SearchViewController(viewModel: SearchViewModel())
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        tableview.rx.modelSelected(CoinInfoResponse.self).subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            let vc = CoinDetailViewController(viewModel: CoinDetailViewModel(id: item.id ?? ""))
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func handleLoading(_ output: WatchListViewModel.Output) {
        output.showLoading.subscribe(onNext: { isLoading in
            
        }).disposed(by: disposeBag)
    }
    
    private func handleRemoveFromWatchlist(_ output: WatchListViewModel.Output) {
        output.resultRemoveFromWatchList.subscribe(onNext: { [weak self] (result, error) in
            guard let self = self else { return }
            if result {
                self.trigger.onNext(())
            } else {
                self.showToast(message: error, font: UIFont.systemFont(ofSize: 12)) { _ in
                    
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func handleBindingTableView(_ output: WatchListViewModel.Output) {
        output.watchList.flatMap { [weak self] listData -> Observable<[SectionModel<String, CoinInfoResponse>]> in
            guard let self = self else {
                return .empty()
            }
            self.listData = listData
            self.emptyView.isHidden = !listData.isEmpty
            self.tableview.isHidden = listData.isEmpty
            return Observable.just([SectionModel(model: "", items: listData)])
        }.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

}

extension WatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderMarketView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favourite = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            self.removeFromWatchList.accept(self.listData[indexPath.row].id ?? "")
            print("Delete: \(indexPath.row + 1)")
            completionHandler(true)
        }
        favourite.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(systemName: "star")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        favourite.backgroundColor = .white
        
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [favourite])
        
        return swipe
    }
}
