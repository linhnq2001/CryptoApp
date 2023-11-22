//
//  TransactionHistoryVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/11/2023.
//

import UIKit
import RxSwift
import RxDataSources

class TransactionHistoryVC: UIViewController {

    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.register(UINib(nibName: "TransactionHistoryCell", bundle: nil), forCellReuseIdentifier: "TransactionHistoryCell")
        }
    }
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, TradeDetailHistory>> { dataSource, tableview, indexPath, item in
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "TransactionHistoryCell", for: indexPath) as? TransactionHistoryCell else {
            return UITableViewCell()
        }
        cell.configData(data: item)
        return cell
    }
    private(set) var viewModel: TransactionHistoryViewModel!
    private let trigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: TransactionHistoryViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: TransactionHistoryVC.self), bundle: Bundle(for: TransactionHistoryVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
    }
    
    private func bindingData() {
        let input = TransactionHistoryViewModel.Input(trigger: trigger)
        let output = viewModel.transform(input)
        handleBindingTableView(output)
        trigger.onNext(())
        tableview.rx.modelSelected(TradeDetailHistory.self).subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            let vc = TransactionDetailVC(data: data, name: viewModel.getName(), didEditPortfolio: self.viewModel.didEditPortfolio)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func handleBindingTableView(_ output: TransactionHistoryViewModel.Output) {
        output.listTransactionHistory.bind(to: tableview.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
