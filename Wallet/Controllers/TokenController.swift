//
//  TokenController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit

class TokenController: UITableViewController {
    
    private var token: Token
    let standardCell = "standardCell"
    let tradeCell = "tradeCell"
    let cardCell = "assetCell"
    
    lazy var header: TokenHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 360)
        let view = TokenHeaderView(frame: frame, token: token)
        view.token = self.token
        view.delegate = self
        return view
    }()
    
    init(_ token: Token) {
        self.token = token
        super.init(style: .grouped)
        tableView.tableHeaderView = header
        self.navigationItem.title = token.assetCode
        getLastPrice()
        customization()
    }
    
    func customization() {
        tableView.backgroundColor = .black
    }
    
    func getLastPrice() {
        TokenService.getLastPrice(token: token) { (price) in
            self.header.lastPrice = price
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var payments: [Payment] = [] {
        didSet {
            tableView.reloadData()
            setupEmptyView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.register(TradeCell.self, forCellReuseIdentifier: tradeCell)
        tableView.register(CardCell.self, forCellReuseIdentifier: cardCell)
    }

    
    lazy var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 80))
        label.text = "No transactions yet."
        label.textColor = Theme.gray
        label.font = Theme.medium(20)
        label.textAlignment = .center
        return label
    }()
    
    func setupEmptyView() {
        if payments.count == 0 {
            self.tableView.backgroundView = emptyLabel
        } else {
            self.tableView.backgroundView = nil
        }
        print(payments.count)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getLastPrice()
    }
   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return payments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tradeCell, for: indexPath) as! TradeCell
        //        cell.trade = trades[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,1):
            pushOrderbookController()
        default:
            break
        }
    }
    
    
    
    func pushOrderbookController() {
        let vc = OrderbookController()
        vc.token = token
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleScanTap() {
        let vc = ScanController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSendTap() {
//        let vc = UsersController(style: .grouped)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension TokenController: TokenHeaderDelegate {
    
    func handleOrderTap(token: Token?, side: TransactionType) {
//        let token = token ?? counterAsset
//        let vc = OrderController(token: token, side: side)
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true)
    }
    
}
