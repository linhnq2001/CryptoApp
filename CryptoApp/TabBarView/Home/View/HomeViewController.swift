//
//  HomeViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var tableview: UITableView!
    
    private(set) var viewModel: HomeViewModel!
    
    init(viewModel: HomeViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
