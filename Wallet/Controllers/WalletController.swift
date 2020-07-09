//
//  WalletController.swift
//  Wallet
//
//  Created by Hackr on 6/18/20.
//  Copyright © 2020 Sugar. All rights reserved.
//

import UIKit

protocol WalletRefreshDelegate {
    func getData(_ refresh: UIRefreshControl?)
}

class WalletController: UITableViewController {
    
    private var searchController: UISearchController!
    private var refresh = UIRefreshControl()
    
    let tradeCell = "paymentCell"
    
    var token: Token = Token.XAU {
        didSet {
            self.header.token = token
            tableView.reloadData()
        }
    }
    
    var trades: [Trade] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var headerHeight: CGFloat = self.view.frame.width*0.62+160
    
    lazy var header: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerHeight))
        view.delegate = self
        view.card.cardImageView.image = UIImage(named: "card")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Wallet"
        tableView.backgroundColor = Theme.white
        view.backgroundColor = Theme.black
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        extendedLayoutIncludesOpaqueBars = true
        tableView.refreshControl = refresh
        tableView.register(TradeCell.self, forCellReuseIdentifier: tradeCell)
        
        refresh.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "user"), style: .done, target: self, action: #selector(handlePlusTap))
        getData(nil)
    }
    
    @objc func handlePlusTap() {
        let vc = AccountController(style: .grouped)
            
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getData(_ refresh: UIRefreshControl?) {
        print("GET DATA")
        getAsset()
        getTrades()
        getRate()
    }
    
    func getRate() {
        RateManager.getPrice(assetCode: "XAU") { (price) in
            print("PRICE: \(price)")
            self.header.priceView.price = price
        }
    }
    
    func getAsset() {
        WalletService.getAccountDetails() { (token) in
            self.refresh.endRefreshing()
            guard let token = token else { return }
            self.token = token
        }
    }
    
    func getTrades() {
        PaymentService.getOrders { (orders) in
            self.trades = orders.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Passphrase: \(KeychainHelper.mnemonic)")
        print("Public Key: \(KeychainHelper.publicKey)")
        print("Secret Key: \(KeychainHelper.privateSeed)")
        
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refresh.endRefreshing()
    }
    
    
    @objc func handleMoreTap() {
        let vc = AccountController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func auth() {
        guard KeychainHelper.publicKey != "" else {
            handleLoggedOut()
            return
        }
        getData(nil)
    }
    
    
    func handleLoggedOut() {
        guard CurrentUser.token != "" else {
            presentHomeController()
            return
        }
        guard KeychainHelper.publicKey != "" else {
            presentWalletLogin()
            return
        }
    }
    
    func presentHomeController() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    func presentWalletLogin() {
        let vc = WalletLoginController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trades.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tradeCell, for: indexPath) as! TradeCell
        cell.trade = trades[indexPath.row]
        return cell
    }
    
    private func getLastPrice(token: Token, cell: CardCell) {
        TokenService.getLastPrice(token: token) { (amount) in
//            cell.balanceLabel.text = amount
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trade = trades[indexPath.row]
        pushReceiptController(trade)
    }
    
    func pushReceiptController(_ trade: Trade) {
        let assetCode = trade.counterAssetCode ?? ""
        let side = trade.side ?? ""
        let size = trade.size ?? ""
        let price = trade.price ?? ""
        let subtotal = trade.subtotal ?? ""
        let fee = trade.fee ?? ""
        
        let total = trade.total ?? ""
        let date = trade.timestamp.medium()
        let status = trade.status ?? "pending"
        
        let data = [
            (key: "Date", value: date),
            (key: side.capitalized, value: size.rounded(4) + " \(assetCode)"),
            (key: "Price", value: price.currency()),
            (key: "Subtotal", value: subtotal.currency()),
            (key: "Processing Fee", value: fee.currency()),
            (key: "Total", value: total.currency()),
            (key: "Status", value: status.capitalized),
        ]
        
        let vc = ReceiptController(data)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}



extension WalletController: WalletHeaderDelegate {
    
    func handleQRTap() {
        
    }
    
    func handleCardTap() {
        print("Present card")
        auth()
    }
    
    func presentOrderController(side: TransactionType) {
        let vc = CardOrderController(token: token, side: .buy)
        vc.walletRefreshDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    
}


extension WalletController: WalletRefreshDelegate {

}
