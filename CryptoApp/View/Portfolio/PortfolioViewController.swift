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
    private var selectedPortfolio: Portfolio?
    private let trigger = PublishSubject<Void>()
    private let actionChangePortfolio = PublishSubject<Portfolio>()
    private let actionCreatePortfolio = PublishSubject<Portfolio>()
    
    @IBOutlet weak var collectionview: UICollectionView! {
        didSet {
            collectionview.register(UINib(nibName: "NewPortfolioCell", bundle: nil), forCellWithReuseIdentifier: "NewPortfolioCell")
            collectionview.register(UINib(nibName: "PortfolioCell", bundle: nil), forCellWithReuseIdentifier: "PortfolioCell")
            collectionview.rx.setDelegate(self).disposed(by: disposeBag)
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var newPortfolioView: UIView!
    
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
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PortfolioSection>  { dataSource, collectionview, indexPath, item in
        guard let newPortfolioCell = collectionview.dequeueReusableCell(withReuseIdentifier: "NewPortfolioCell", for: indexPath) as? NewPortfolioCell, let portfolioCell = collectionview.dequeueReusableCell(withReuseIdentifier: "PortfolioCell", for: indexPath) as? PortfolioCell else {
            return UICollectionViewCell()
        }
        switch dataSource.sectionModels[indexPath.section].model {
        case .newPortfolio:
            return newPortfolioCell
        case .portfolio:
            portfolioCell.configData(data: item,triggerUpdatePrice: self.viewModel.triggerUpdatePrice)
            return portfolioCell
        }
    }
    
    init(viewModel: PortfolioViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: PortfolioViewController.self), bundle: Bundle(for: PortfolioViewController.self))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
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
            if self.selectedPortfolio == nil {
                guard let firstPortfolio = listSection.first(where: {$0.model == .portfolio})?.items.first as? Portfolio else {return}
                self.actionChangePortfolio.onNext(firstPortfolio)
                self.selectedPortfolio = firstPortfolio
            }
        }).disposed(by: disposeBag)

        output.listPortfolio.bind(to: collectionview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    private func handleListToken(_ output: PortfolioViewModel.Output) {
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
    }
    
    @IBAction func didTapAddNewCoin(_ sender: Any) {
        let vc = ChooseAssetVC(viewModel: ChooseAssetViewModel(portfolioName: self.selectedPortfolio?.name, portfolio: self.selectedPortfolio))
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension PortfolioViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: collectionView.frame.size.height)
    }
}
