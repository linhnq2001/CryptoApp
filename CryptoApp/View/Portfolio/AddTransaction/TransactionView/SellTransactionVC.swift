//
//  SellTransactionVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 15/11/2023.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class SellTransactionVC: UIViewController {

    private var tokenId: String
    private(set) var data: CoinInMarketResponse?
    private(set) var portfolio: Portfolio?
    private(set) var didEditPortfolio: PublishSubject<Void>

    private let repository = DefaultMarketRepository()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var totalTF: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var portfolioView: UIView!
    
    @IBOutlet weak var marketPriceView: UIView!
    @IBOutlet weak var marketLb: UILabel!
    
    @IBOutlet weak var customPriceView: UIView!
    @IBOutlet weak var customLb: UILabel!
    
    var selectedDate: Double = Date().stripTime().timeIntervalSince1970 {
        didSet {
            timeStamp = selectedDate + selectedTime
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy" // "dd" for day, "MMMM" for month, and "yyyy" for year
            let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: selectedDate))
            self.dateLb.text = formattedDate
        }
    }
    var selectedTime: Double = Date().timeIntervalSince1970 - Date().stripTime().timeIntervalSince1970 {
        didSet {
            timeStamp = selectedDate + selectedTime
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm" // "dd" for day, "MMMM" for month, and "yyyy" for year
            let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: self.selectedTime + self.selectedDate))
            self.timeLb.text = formattedDate
        }
    }
    var timeStamp: Double = 0
    
    init(tokenId: String,
         data: CoinInMarketResponse? = nil,
         portfolio: Portfolio?,
         didEditPortfolio: PublishSubject<Void>) {
        self.tokenId = tokenId
        self.data = data
        self.portfolio = portfolio
        self.didEditPortfolio = didEditPortfolio
        super.init(nibName: String(describing: SellTransactionVC.self), bundle: Bundle(for: SellTransactionVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        if let data = data {
            if let price = data.currentPrice {
                self.priceTF.text = "\(price)"
            }
            
        } else {
            getPrice()
        }
        setupTF()
        portfolioView.addShadow()
        // Do any additional setup after loading the view.
    }
    
    private func setupTF() {
        self.marketLb.textColor = UIColor.blue.withAlphaComponent(0.8)
        self.marketPriceView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.customLb.textColor = .black
        self.customPriceView.backgroundColor = UIColor(hex: "#F3F3F6")
        if let data = data {
            if let price = data.currentPrice {
                self.priceTF.text = "\(price)"
            }
        } else {
            getPrice()
        }
        amountTF.rx.controlEvent(.editingChanged).withLatestFrom(amountTF.rx.text.orEmpty).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if let amount = Double(text) , let currentPrice = Double(self.priceTF.text ?? "") {
                self.totalTF.text = "\(amount * currentPrice)"
            }
        }).disposed(by: disposeBag)
        
        totalTF.rx.controlEvent(.editingChanged).withLatestFrom(totalTF.rx.text.orEmpty).subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if let total = Double(text) , let currentPrice = Double(self.priceTF.text ?? "") {
                self.amountTF.text = "\(total / currentPrice)"
            }
        }).disposed(by: disposeBag)
        
        priceTF.rx.controlEvent(.editingChanged).subscribe(onNext: { [weak self] _ in
            self?.marketLb.textColor = .black
            self?.marketPriceView.backgroundColor = UIColor(hex: "#F3F3F6")
            self?.customLb.textColor = UIColor.blue.withAlphaComponent(0.8)
            self?.customPriceView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            if  let amount = Double(self?.amountTF.text ?? "0"),
                let currentPrice = Double(self?.priceTF.text ?? "") , amount != 0 {
                self?.totalTF.text = "\(amount * currentPrice)"
            }
        }).disposed(by: disposeBag)
    }
    
    private func getPrice() {
        let simplePrice: Observable<SimplePriceResponse> = self.repository.getSimplePrice(id: self.tokenId, currency: "usd")
        simplePrice.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            if let price = response[self.tokenId]?.usd {
                self.priceTF.text = "\(price)"
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupTapGesture() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGes)
        let selectDate = UITapGestureRecognizer(target: self, action: #selector(didSelectDate))
        dateView.addGestureRecognizer(selectDate)
        let selectTime = UITapGestureRecognizer(target: self, action: #selector(didSelectTime))
        timeView.addGestureRecognizer(selectTime)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didSelectDate() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRectMake(15, 0, self.view.frame.width - 30, 200)
        //        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        // Create an alert with a date picker
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        // Add the date picker to the alert controller
        alertController.view.addSubview(datePicker)
        
        // Add "Cancel" and "Done" buttons
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Handle the selected date (if needed)
            var date = datePicker.date.stripTime()
            self.selectedDate = date.timeIntervalSince1970
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    @objc func didSelectTime() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.frame = CGRectMake(15, 0, self.view.frame.width - 30, 200)
        //        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        // Create an alert with a date picker
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        // Add the date picker to the alert controller
        alertController.view.addSubview(datePicker)
        
        // Add "Cancel" and "Done" buttons
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            // Handle the selected date (if needed)
            self.selectedTime = datePicker.date.timeIntervalSince1970 - datePicker.date.stripTime().timeIntervalSince1970
        }))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddTransaction(_ sender: Any) {
        guard let price = Double(self.priceTF.text ?? ""),
              let amount = Double(self.amountTF.text ?? "") else {
            return
        }
        let trasaction = TradeHistory(type: .sell, price: price, amount: amount, createAt: Int(timeStamp))
        let tokenInPortfolio = TokenInPortfolio(id: tokenId, name: data?.name ?? "", symbol: data?.symbol?.uppercased() ?? "", urlImage: data?.image ?? "", tradesHistory: [trasaction])
        FirestoreHelper.shared.addTransaction(tokenInPortfolio, namePortfolio: portfolio?.name ?? "").subscribe(onNext: { [weak self] result , error in
            guard let self = self else {return}
            if result {
                self.didEditPortfolio.onNext(())
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
}
extension SellTransactionVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "Sell")
    }
}
