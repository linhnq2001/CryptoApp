//
//  HomeViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxDataSources
import RxSwift
import RxRelay

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    private let trigger = PublishSubject<Void>()
    private let tapToWatchList = PublishRelay<CoinInMarketResponse>()
    private let disposeBag = DisposeBag()
    private(set) var viewModel: HomeViewModel!
    private var listData: [CoinInMarketResponse] = []
    
    let dataSource = RxTableViewSectionedReloadDataSource <SectionModel<String, CoinInMarketResponse>>(configureCell: { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "CoinInfoTableViewCell", for: indexPath) as? CoinInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.configData(data: item)
        return cell
    })
    
    init(viewModel: HomeViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        setupTableView()
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearch))
        searchView.addGestureRecognizer(searchTapGesture)
    }
    
    @objc private func didTapSearch(){
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func setupTableView(){
        tableview.rx.setDelegate(self).disposed(by: disposeBag)
        tableview.register(UINib(nibName: "CoinInfoTableViewCell", bundle: .main), forCellReuseIdentifier: "CoinInfoTableViewCell")
        tableview.rowHeight = 60
        tableview.rx.modelSelected(CoinInMarketResponse.self).subscribe(onNext: {model in
            
        }).disposed(by: disposeBag)
    }
    
    private func bindingData() {
        let input = HomeViewModel.Input(trigger: trigger, tapToWatchList: tapToWatchList)
        
        let output = viewModel.transform(input)
        handleLoading(output)
        handleBindingTableView(output)
        handleAddOrRemoveWatchList(output)
        trigger.onNext(())
        
    }
    
    private func handleAddOrRemoveWatchList(_ output: HomeViewModel.Output) {
        output.didTapToWatchList.subscribe(onNext: {(result, context) in
            print("Linhdebug \(result) \(context)")
        }).disposed(by: disposeBag)
    }
    
    private func handleBindingTableView(_ output: HomeViewModel.Output) {
        output.marketResponse.flatMap { [weak self] listData -> Observable<[SectionModel<String, CoinInMarketResponse>]> in
            guard let self = self else {
                return .empty()
            }
            self.listData = listData
            return Observable.just([SectionModel(model: "", items: listData)])
        }.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func handleLoading(_ output: HomeViewModel.Output) {
        output.showLoading.subscribe(onNext: { isLoading in
            
        }).disposed(by: disposeBag)
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderMarketView()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favourite = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("Delete: \(indexPath.row + 1)")
            completionHandler(true)
        }
        favourite.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(systemName: "star")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        favourite.backgroundColor = .white
        
        // share
        let notification = UIContextualAction(style: .normal, title: "Share") { (action, view, completionHandler) in
            print("Share: \(indexPath.row + 1)")
            completionHandler(true)
        }
        notification.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(systemName: "star")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        notification.backgroundColor = .white
        
        // download
        let portfolio = UIContextualAction(style: .normal, title: "Download") { [weak self] (action, view, completionHandler) in
            guard let self = self else {
                completionHandler(true)
                return
            }
            self.tapToWatchList.accept(self.listData[indexPath.row])
            completionHandler(true)
        }
        portfolio.image = UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(systemName: "star")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30))
        }
        portfolio.backgroundColor = .white
        
        
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [favourite, notification, portfolio])
        
        return swipe
    }
}
