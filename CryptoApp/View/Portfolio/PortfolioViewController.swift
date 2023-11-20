//
//  PortfolioViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxSwift
import RxDataSources

public enum PortfolioTitle {
    case portfolio
    case newPortfolio
}

typealias PortfolioSection = SectionModel<PortfolioTitle,PortfolioDataSource>
public protocol PortfolioDataSource {
}

public class NewPortfolioData: PortfolioDataSource {
    
}

class PortfolioViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private(set) var viewModel: PortfolioViewModel!
    private var sections: [PortfolioSection] = [] {
        didSet {
            emptyView.isHidden = true
            newPortfolioView.isHidden = true
            portfolioView.isHidden = true
            if sections.count == 1 {
                newPortfolioView.isHidden = false
            } else if sections.count == 2 {
                guard let portfolio = sections.first?.items.first as? Portfolio else { return }
                if !portfolio.listToken.isEmpty {
                    portfolioView.isHidden = false
                } else {
                    emptyView.isHidden = false
                }
            }
        }
    }
    private var selectedPortfolio: Portfolio? {
        didSet {
            if selectedPortfolio == nil {
                newPortfolioView.isHidden = false
                portfolioView.isHidden = true
                emptyView.isHidden = true
            } else {
                newPortfolioView.isHidden = true
                if let listToken = selectedPortfolio?.listToken , !listToken.isEmpty {
                    portfolioView.isHidden = false
                    emptyView.isHidden = true
                } else {
                    portfolioView.isHidden = true
                    emptyView.isHidden = false
                }
            }
        }
    }
    private let trigger = PublishSubject<Void>()
    private let actionChangePortfolio = PublishSubject<Portfolio>()
    private let actionCreatePortfolio = PublishSubject<Portfolio>()
    private let didEditPortfolio = PublishSubject<Void>()
    
    @IBOutlet weak var collectionview: UICollectionView! {
        didSet {
            collectionview.register(UINib(nibName: "NewPortfolioCell", bundle: nil), forCellWithReuseIdentifier: "NewPortfolioCell")
            collectionview.register(UINib(nibName: "PortfolioCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioCell")
            collectionview.rx.setDelegate(self).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var newPortfolioView: UIView!
    @IBOutlet weak var containerNewPortfolioView: UIView! {
        didSet {
            containerNewPortfolioView.addShadow()
        }
    }
    @IBOutlet weak var nameInputTF: InputTextField!
    @IBOutlet weak var chooseColorView: ChooseColorView!
    @IBOutlet weak var portfolioView: UIView!
    @IBOutlet weak var timeFrameView: TimeFrameView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "TokenInPortfolioCell", bundle: nil), forCellReuseIdentifier: "TokenInPortfolioCell")
        }
    }
    
    lazy var tableViewDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,TokenInPortfolio>> { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "TokenInPortfolioCell", for: indexPath) as? TokenInPortfolioCell else { return UITableViewCell() }
        cell.configData(data: item)
        return cell
    }
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PortfolioSection>  {[weak self] dataSource, collectionview, indexPath, item in
        guard let newPortfolioCell = collectionview.dequeueReusableCell(withReuseIdentifier: "NewPortfolioCell", for: indexPath) as? NewPortfolioCell, let portfolioCell = collectionview.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as? PortfolioCell, let self = self else {
            return UICollectionViewCell()
        }
        switch dataSource.sectionModels[indexPath.section].model {
        case .newPortfolio:
            return newPortfolioCell
        case .portfolio:
            portfolioCell.configData(data: item,triggerUpdatePrice: self.viewModel.triggerUpdatePrice)
            portfolioCell.didTapHistoryAction.subscribe(onNext: { _ in
                self.openTransactionHistory()
            }).disposed(by: self.disposeBag)
            portfolioCell.didTapAnalyticsAction.subscribe(onNext: { _ in
                self.openAnalytics()
            }).disposed(by: self.disposeBag)
            return portfolioCell
        }
    }
    
    var didCreatePortfolio: Bool = false
    
    init(viewModel: PortfolioViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PortfolioViewController.self), bundle: Bundle(for: PortfolioViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        trigger.onNext(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    private func bindingData() {
        let input = PortfolioViewModel.Input(trigger: trigger, actionCreatePortfolio: actionCreatePortfolio, actionChangePortfolio: actionChangePortfolio)
        
        let output = viewModel.transform(input)
        handlePortfolioData(output)
        handleListToken(output)
        handleCreatePortfolio(output)
        trigger.onNext(())
        didEditPortfolio.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.trigger.onNext(())
        }).disposed(by: disposeBag)
    }

    private func handleCreatePortfolio(_ output: PortfolioViewModel.Output) {
        output.didCreatePortfolio.subscribe(onNext: {[weak self] (result, error) in
            guard let self = self else { return }
            if result {
                self.trigger.onNext(())
            }
        }).disposed(by: disposeBag)
    }

    private func handlePortfolioData(_ output: PortfolioViewModel.Output) {
        output.listPortfolio.subscribe(onNext: { [weak self] listSection in
            guard let self = self else { return }
            self.sections = listSection
            if let selectedPortfolio = self.selectedPortfolio {
                self.actionChangePortfolio.onNext(selectedPortfolio)
                self.selectedPortfolio = selectedPortfolio
            } else {
                if didCreatePortfolio {
                    guard let lastPortfolio = listSection.first(where: {$0.model == .portfolio})?.items.last as? Portfolio else {return}
                    self.actionChangePortfolio.onNext(lastPortfolio)
                    self.selectedPortfolio = lastPortfolio
                } else {
                    guard let firstPortfolio = listSection.first(where: {$0.model == .portfolio})?.items.first as? Portfolio else {return}
                    self.actionChangePortfolio.onNext(firstPortfolio)
                    self.selectedPortfolio = firstPortfolio
                }
            }
            didCreatePortfolio = false
        }).disposed(by: disposeBag)

        output.listPortfolio.bind(to: collectionview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    private func handleListToken(_ output: PortfolioViewModel.Output) {
        output.listTokenPortfolio.subscribe(onNext: { [weak self] listToken in
            guard let self = self else { return }
            self.newPortfolioView.isHidden = true
            self.emptyView.isHidden = !listToken.isEmpty
            self.portfolioView.isHidden = listToken.isEmpty
        }).disposed(by: disposeBag)
        output.listTokenPortfolio.bind(to: tableView.rx.items(dataSource: tableViewDataSource)).disposed(by: disposeBag)
    }

    @IBAction func didTapAllPortfolio(_ sender: Any) {
        
    }

    
    @IBAction func didTapCreatePortfolio(_ sender: Any) {
        guard let name = nameInputTF.text else {
            return
        }
        let portfolio = Portfolio(name: name, color: chooseColorView.selectedColor, createdAt: Int(Date().timeIntervalSince1970))
        actionCreatePortfolio.onNext(portfolio)
        nameInputTF.text = ""
        didCreatePortfolio = true
    }
    
    @IBAction func didTapAddNewCoin(_ sender: Any) {
        let vc = ChooseAssetVC(viewModel: ChooseAssetViewModel(portfolioName: self.selectedPortfolio?.name, portfolio: self.selectedPortfolio))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddNewCoinInPortfolioView(_ sender: Any) {
        let vc = ChooseAssetVC(viewModel: ChooseAssetViewModel(portfolioName: self.selectedPortfolio?.name, portfolio: self.selectedPortfolio))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        let vc = SearchViewController(viewModel: SearchViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openTransactionHistory() {
        guard let selectedPortfolio = selectedPortfolio else { return }
        let viewModel = TransactionHistoryViewModel(portfolio: selectedPortfolio)
        let vc = TransactionHistoryVC(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openAnalytics() {
        let vc = AnalyticsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapMoreDetail(_ sender: Any) {
        let vc = MoreDetailsVC(portfolio: selectedPortfolio, didEditPortfolio: didEditPortfolio)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(nav, animated: true)
    }
    

}

extension PortfolioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("linhdebug3 \(collectionview.contentOffset.x)")
        var closestCell : UICollectionViewCell = collectionview.visibleCells[0];
        for cell in collectionview!.visibleCells as [UICollectionViewCell] {
            let closestCellDelta = abs(closestCell.center.x - collectionview.bounds.size.width/2.0 - collectionview.contentOffset.x)
            let cellDelta = abs(cell.center.x - collectionview.bounds.size.width/2.0 - collectionview.contentOffset.x)
            if (cellDelta < closestCellDelta){
                closestCell = cell
            }
        }
        if let indexPath = collectionview.indexPath(for: closestCell) {
            let data = sections[indexPath.section]
            if data.model != .newPortfolio, let portfolio = data.items[indexPath.row] as? Portfolio {
                self.selectedPortfolio = portfolio
                self.actionChangePortfolio.onNext(portfolio)
            } else {
                self.selectedPortfolio = nil
            }
            collectionview.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        }
    }
}
