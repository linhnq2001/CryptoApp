//
//  SearchViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

public enum SearchTitle {
    case recentSearch
    case searchResult
    case trendingSearch
}

typealias SearchSection = SectionModel<SearchTitle,SearchDataSource>
public protocol SearchDataSource {
}

public class RecentSearchDataSource: SearchDataSource {
    var listItem: [CoinInfoResponse]
    init(listItem: [CoinInfoResponse]) {
        self.listItem = listItem
    }
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SearchSection> { dataSource, tableview, indexPath, item in
        guard let recentCell = tableview.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell, let searchCell = tableview.dequeueReusableCell(withIdentifier: "CoinInfoTableViewCell", for: indexPath) as? CoinInfoTableViewCell else {
            return UITableViewCell()
        }
        switch dataSource.sectionModels[indexPath.section].model {
        case .recentSearch:
            recentCell.configData(data: item)
            return recentCell
        case .searchResult:
            searchCell.configData(data: item)
            return searchCell
        case .trendingSearch:
            searchCell.configData(data: item)
            return searchCell
        }
    }
    
    private(set) var viewModel: SearchViewModel!
    private let trigger = PublishSubject<Void>()
    private let inSearch = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    private var recentSearchData: [CoinInfoResponse] = []
    private var trendingSearch: TrendingSearchResponse?

    init(viewModel: SearchViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SearchViewController.self), bundle: Bundle(for: SearchViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.delegate = nil
        self.tableview.dataSource = nil
        tableview.register(UINib(nibName: "RecentSearchCell", bundle: nil), forCellReuseIdentifier: "RecentSearchCell")
        tableview.register(UINib(nibName: "CoinInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinInfoTableViewCell")
        bindingData()
        // Do any additional setup after loading the view.
    }
    
    private func bindingData() {
        let input = SearchViewModel.Input(trigger: trigger, inSearch: inSearch)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleSearchResult(output)
        trigger.onNext(())
        searchTF.rx.controlEvent(.editingDidEnd).withLatestFrom(searchTF.rx.text.orEmpty).debounce(.milliseconds(500), scheduler: MainScheduler.instance).bind(to: inSearch).disposed(by: disposeBag)
    }
    
    private func handleLoading(_ output: SearchViewModel.Output) {
        
    }

    private func handleSearchResult(_ output: SearchViewModel.Output) {
        output.searchResult.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
