//
//  HomeViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxDataSources
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    private let trigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private(set) var viewModel: HomeViewModel!
    
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
        let input = HomeViewModel.Input(trigger: trigger)
        
        let output = viewModel.transform(input)
        handleLoading(output)
        handleBindingTableView(output)
        trigger.onNext(())
        
    }
    
    private func handleBindingTableView(_ output: HomeViewModel.Output) {
        output.marketResponse.flatMap { listData -> Observable<[SectionModel<String, CoinInMarketResponse>]> in
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
}
