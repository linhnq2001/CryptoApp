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
    case marketCoin
    case portfolioCoin
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

    @IBOutlet private weak var searchTF: UITextField!
    @IBOutlet private weak var tableview: UITableView!
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SearchSection> { dataSource, tableview, indexPath, item in
        guard let recentCell = tableview.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchCell,
              let searchCell = tableview.dequeueReusableCell(withIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchCell else {
            return UITableViewCell()
        }
        switch dataSource.sectionModels[indexPath.section].model {
        case .recentSearch:
            recentCell.configData(data: item)
            recentCell.didTapClearRecentSearch = { [weak self] in
                guard let self = self else { return }
                self.actionCleanRecent.onNext(())
            }
            return recentCell
        case .searchResult:
            searchCell.configData(data: item, type: .searchResult)
            return searchCell
        case .trendingSearch:
            searchCell.configData(data: item, type: .trendingSearch)
            return searchCell
        default:
            return UITableViewCell()
        }
    }
    
    private(set) var viewModel: SearchViewModel!
    private let trigger = PublishSubject<Void>()
    private let inSearch = PublishRelay<String>()
    private let actionTapToken = PublishRelay<(SearchTitle, String)>()
    private let actionCleanRecent = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var recentSearchData: [CoinInfoResponse] = []
    private var trendingSearch: TrendingSearchResponse?
    private var listSection: [SearchSection] = []
    private var firstAppear: Bool = true

    init(viewModel: SearchViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: SearchViewController.self), bundle: Bundle(for: SearchViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !firstAppear {
            trigger.onNext(())
        }
        firstAppear = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        setupTableview()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableview() {
        tableview.register(UINib(nibName: "RecentSearchCell", bundle: nil), forCellReuseIdentifier: "RecentSearchCell")
        tableview.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "ResultSearchCell")
        tableview.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {return}
                switch self.listSection[indexPath.section].model {
                case .recentSearch: 

                    break
                case .searchResult:
                    guard let data = self.listSection[indexPath.section].items[indexPath.row] as? CoinSearchResponse else {return}
                    let id = data.id ?? ""
                    self.actionTapToken.accept((.searchResult, id))
                    let viewModel = CoinDetailViewModel(id: id)
                    let vc = CoinDetailViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .trendingSearch:
                    guard let data = self.listSection[indexPath.section].items[indexPath.row] as? CoinItem else {return}
                    let id = data.item?.id ?? ""
                    self.actionTapToken.accept((.trendingSearch, id))
                    let viewModel = CoinDetailViewModel(id: id)
                    let vc = CoinDetailViewController(viewModel: viewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    break
                }
                print("selected with indextPath: \(indexPath)")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindingData() {
        let input = SearchViewModel.Input(trigger: trigger, inSearch: inSearch, actionTapToken: actionTapToken, actionCleanRecent: actionCleanRecent)
        let output = viewModel.transform(input)
        handleLoading(output)
        handleSearchResult(output)
        trigger.onNext(())
        searchTF.rx.controlEvent(.editingDidEnd).withLatestFrom(searchTF.rx.text.orEmpty).bind(to: inSearch).disposed(by: disposeBag)
    }
    
    private func handleLoading(_ output: SearchViewModel.Output) {
        
    }

    private func handleSearchResult(_ output: SearchViewModel.Output) {
        output.searchResult.subscribe(onNext: { [weak self] section in
            guard let self = self else {
                return
            }
            self.listSection = section
        }).disposed(by: disposeBag)

        output.searchResult.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
