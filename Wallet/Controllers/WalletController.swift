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
    
    var token: Token {
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
    
    var headerHeight: CGFloat = UIScreen.main.bounds.width*0.62+160
    
    let header: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.62+160))
        return view
    }()
    
    init(_ token: Token) {
        self.token = token
        super.init(style: .grouped)
        getData(nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
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
        
        header.priceView.titleLabel.text = "Subscription"
//        header.priceView.priceLabel.text = "Select Amount"
    }
    
    
    @objc func getData(_ refresh: UIRefreshControl?) {
        getAsset()
        getTrades()
//        getRate()
        getPlans()
    }
    
    func getPlans() {
        let plan = plans[token.assetCode]
        let amount = plan?.amount ?? 0.0
        self.header.priceView.priceLabel.text = amount.currency(2) + " / Mo."
    }
    
    func getRate() {
//        RateManager.getPrice(assetCode: token.assetCode) { (price) in
//            print("ASSET: \(self.token.assetCode)")
//            print("PRICE: \(price)")
//            self.header.priceView.price = price
//        }
    }
    
    func getAsset() {
        WalletService.getAsset(assetCode: token.assetCode) { (token) in
            self.refresh.endRefreshing()
            guard let token = token else { return }
            self.token = token
        }
    }
    
    func getTrades() {
        PaymentService.getOrders { (orders) in
//            self.trades = orders.sorted { $0.timestamp > $1.timestamp }
        }
        self.trades = Trade.getTradesFor(assetCode: token.assetCode)
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
    
    func presentAmountController() {
        let vc = AmountController(assetCode: token.assetCode)
        vc.planDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Transactions"
        default:
            return ""
        }
    }
    
}



extension WalletController: WalletHeaderDelegate {
    
    func handlePriceViewTap() {
        guard let plan = plans[token.assetCode] else {
            presentAmountController()
            return
        }
        let vc = PlanController(plan: plan)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func handleButtonTap() {
        presentAmountController()
    }
    
    func handleCardTap() {
        
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



extension WalletController: PlanDelegate {
    
    func pushPlanController(_ plan: Plan) {
        getData(nil)
        let vc = PlanController(plan: plan)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didCancelSubscription() {
        getData(nil)
    }
    
}



