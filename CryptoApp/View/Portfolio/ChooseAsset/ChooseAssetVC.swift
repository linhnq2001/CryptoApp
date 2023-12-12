//
//  ChooseAssetVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 13/11/2023.
//

import UIKit
import RxSwift
import RxDataSources
import RxRelay

class ChooseAssetVC: UIViewController {
    private let disposeBag = DisposeBag()
    private(set) var viewModel: ChooseAssetViewModel!
    private let trigger = PublishSubject<Void>()
    private let inSearch = PublishRelay<String>()
    private let choosseAsset = PublishRelay<String>()
    private var sections: [SearchSection] = []
    
    @IBOutlet private weak var searchTF: UITextField!
    @IBOutlet private weak var tableview: UITableView! {
        didSet {
            tableview.register(UINib(nibName: "ChooseAssetCell", bundle: nil), forCellReuseIdentifier: "ChooseAssetCell")
            tableview.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
                guard let self = self else {return}
                let sectiontype = self.sections[indexPath.section].model
                switch sectiontype {
                case .portfolioCoin:
                    guard let data = self.sections[indexPath.section].items[indexPath.row] as? TokenInPortfolio else { return }
                    self.goToAddTransaction(id: data.id)
                case .marketCoin:
                    guard let data = self.sections[indexPath.section].items[indexPath.row] as? CoinInMarketResponse else {return}
                    self.goToAddTransaction(id: data.id, data: data)
                case .searchResult:
                    guard let data = self.sections[indexPath.section].items[indexPath.row] as? CoinSearchResponse else {return}
                    self.goToAddTransaction(id: data.id ?? "")
                default:
                    break
                }
            }).disposed(by: disposeBag)
        }
    }
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SearchSection> { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "ChooseAssetCell", for: indexPath) as? ChooseAssetCell else {
            return UITableViewCell()
        }
        cell.configData(data: item, type: dataSource.sectionModels[indexPath.section].model)
        return cell
    }
    init(viewModel: ChooseAssetViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ChooseAssetVC.self), bundle: Bundle(for: ChooseAssetVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
    }
    
    private func bindingData() {
        let input = ChooseAssetViewModel.Input(trigger: trigger, inSearch: inSearch, choosseAsset: choosseAsset)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleSearchResult(output)
        trigger.onNext(())
        searchTF.rx.controlEvent(.editingDidEnd).withLatestFrom(searchTF.rx.text.orEmpty).bind(to: inSearch).disposed(by: disposeBag)
    }
    
    private func handleLoading(_ output: ChooseAssetViewModel.Output) {
        
    }
    
    private func handleSearchResult(_ output: ChooseAssetViewModel.Output) {
        output.searchResult.subscribe(onNext: {[weak self] sections in
            guard let self = self else {return}
            self.sections = sections
        }).disposed(by: disposeBag)
        output.searchResult.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToAddTransaction(id: String, data: CoinInMarketResponse? = nil) {
        let vc = AddTransactionVC(id: id,
                                  data: data,
                                  portfolio: viewModel.portfolio,
                                  didEditPortfolio: viewModel.didEditPortfolio)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
