//
//  ViewController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//
//
//import UIKit
//import PassKit
//
//class HoldingsController: UITableViewController {
//
//    let paymentCell = "paymentCell"
//    let standardCell = "standardCell"
//    let sendView = "sendView"
//
//    private let refresh = UIRefreshControl()
//
//    var sharePrice: String = "0.000" {
//        didSet {
//
//        }
//    }
//
//    var baseCurrency: Token? = nil {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//
//    var assets: [Token] = [] {
//        didSet {
//            counterAsset = assets.filter { $0.assetCode == "DMT" }.first ?? Token.DMT
//            let USD = assets.filter { $0.assetCode == "USD" }.first
//            baseCurrency = USD
//            header.asset = counterAsset
//            tableView.reloadData()
//        }
//    }
//
//
//       var payments: [Payment] = [] {
//           didSet {
//               tableView.reloadData()
//               refresh.endRefreshing()
//           }
//       }
//
//    var trades: [Trade] = [] {
//        didSet {
//            tableView.reloadData()
//            refresh.endRefreshing()
//        }
//    }
//
//
//
//    lazy var toolbar: UIToolbar = {
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
//        let view = UIToolbar(frame: frame)
//        view.backgroundColor = Theme.background
//        return view
//    }()
//
//    override var inputAccessoryView: UIView? {
//        return toolbar
//    }
//
//
//    lazy var header: WalletHeaderView = {
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400)
//        let view = WalletHeaderView(frame: frame)
//        view.delegate = self
//        return view
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        tableView.tableHeaderView = header
//        navigationController?.view.backgroundColor = .white
//        tableView.refreshControl = refresh
//        header.delegate = self
//        refresh.tintColor = Theme.white
//        title = "DELÉMONT"
//        tableView.backgroundColor = Theme.tint
//
//        tableView.showsVerticalScrollIndicator = false
//        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
//
//        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
//        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
//        tableView.register(SendView.self, forHeaderFooterViewReuseIdentifier: sendView)
//        extendedLayoutIncludesOpaqueBars = true
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//        let button = UIBarButtonItem(title: "Send >", style: .done, target: self, action: #selector(handleSend))
//        self.navigationItem.rightBarButtonItem = button
//
//        auth()
//    }
//
//    @objc func handleSend() {
//        let vc = SendController(Token.DMT)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
////    @objc func handleSend() {
////        let vc = UsersController(style: .grouped)
////        let nav = UINavigationController(rootViewController: vc)
////        self.present(nav, animated: true)
////    }
//
//
//    func getLastPrice() {
//        OrderService.bestPrices(buy: baseAsset, sell: counterAsset) { (bestOffer, _) in
//            lastPrice = bestOffer
//            print("Last Market Price: \(lastPrice)")
////            self.navView.text = (bestOffer).currency(0)
////            self.header.lastPrice = bestOffer
//        }
//    }
//
//    func auth() {
//         guard KeychainHelper.publicKey != "" else {
//             presentHomeController()
//             return
//         }
//        getData(nil)
//     }
//
//
//    func presentHomeController() {
//        let vc = HomeController()
////        vc.delegate = self
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .overFullScreen
//        nav.modalTransitionStyle = .crossDissolve
//        present(nav, animated: true, completion: nil)
//    }
//
//
//    @objc func pushAccount() {
//        let vc = AccountController(style: .grouped)
//        let nav = UINavigationController(rootViewController: vc)
////        nav.modalPresentationStyle = .overFullScreen
//        present(nav, animated: true, completion: nil)
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    lazy var navView: UILabel = {
//        let frame = CGRect(x: 0, y: 0, width: 90, height: 36)
//        let view = UILabel(frame: frame)
//        view.text = "Send"
//        view.font = Theme.bold(16)
//        view.textAlignment = .center
//        view.layer.cornerRadius = 18
//        view.backgroundColor = Theme.background
//        view.textColor = .black
//        var tap = UITapGestureRecognizer(target: self, action: #selector(presentUserController))
//        view.addGestureRecognizer(tap)
//        view.isUserInteractionEnabled = true
//        view.clipsToBounds = true
//        return view
//    }()
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getLastPrice()
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    @objc func presentUserController() {
//        let vc = UsersController(style: .grouped)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func getTrades() {
//        WalletService.getTrades { (trades) in
//            self.trades = trades
//        }
//    }
//
//    @objc func handleScan() {
//        let vc = ScanController()
//        //        vc.delegate = self
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalTransitionStyle = .crossDissolve
//        nav.modalPresentationStyle = .fullScreen
//        present(nav, animated: true, completion: nil)
//    }
//
//    @objc func handleSendTap() {
//        let vc = UsersController(style: .grouped)
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
//    }
//
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        refresh.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
//        getData(nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        refresh.endRefreshing()
//
//    }
//
//
//    @objc func getData(_ refresh: UIRefreshControl?) {
//        refresh?.beginRefreshing()
//        getAssets()
//        getLastPrice()
////        getTrades()
//
//        print(KeychainHelper.publicKey)
//        print(KeychainHelper.privateSeed)
//        print(KeychainHelper.mnemonic)
//        fetchPayments()
//    }
//
//    func fetchPayments() {
//           payments = Payment.fetchAll()
//           WalletService.fetchPayments { (payments) in
//               self.payments = payments
//           }
//       }
//
//    func getAssets() {
//        WalletService.getAssets { (assets) in
//            self.assets = assets.filter{ $0.assetCode == "DMT" }
//
//            let DMT = assets.filter{ $0.assetCode == "DMT" }.first ?? Token.DMT
//            counterAsset = DMT
//
//            self.baseCurrency = assets.filter{ $0.assetCode == "USD" }.first
//        }
//    }
//
//
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return payments.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
//        cell.payment = payments[indexPath.row]
//        return cell
//    }
//
//    func setupCell(cell: StandardCell, _ indexPath: IndexPath) {
//           cell.selectionStyle = .none
//
//           switch (indexPath.section, indexPath.row) {
//           case (0,0):
//               cell.titleLabel.text = "Net Asset Value"
//               cell.valueLabel.text = NAV.currency(2)
//           case (0,1):
//               cell.titleLabel.text = "Shares"
//               cell.valueLabel.text = "0.000"
//           case (0,2):
//            let balance: Decimal = Decimal(string: counterAsset.balance) ?? 0.0
//               cell.titleLabel.text = "Account Value"
//            cell.valueLabel.text = (balance*NAV).currency(2)
//           case (1,_):
//
//               cell.valueLabel.text = "0.0%"
//           default:
//               break
//           }
//
//       }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 80
//        default:
//            return 80
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//          switch section {
//          case 0:
//              return 320
//          default:
//              return 60
//          }
//      }
//
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        pushPaymentController(payments[indexPath.row])
//    }
//
//    func pushTokenController(_ asset: Token) {
//        let vc = TokenController(asset)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func pushPaymentController(_ payment: Payment) {
//        let vc = PaymentController(payment: payment)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func handleQRTap() {
//        let vc = QRController()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true, completion: nil)
//    }
//
//    func pushOrderBook() {
//
//    }
//
//
//}
//
//
//
//
//
//extension HoldingsController: FloatingButtonDelegate {
//
//    func handleTap() {
////        if payments.count == 0 {
////            let vc = QRController()
////            let nav = UINavigationController(rootViewController: vc)
////            nav.modalTransitionStyle = .crossDissolve
////            nav.modalPresentationStyle = .fullScreen
////            present(nav, animated: true) {}
////        } else {
//            let vc = UsersController(style: .grouped)
//            let nav = UINavigationController(rootViewController: vc)
//            present(nav, animated: true) {}
////        }
//    }
//}
//
//
//extension HoldingsController: WalletHeaderDelegate {
//
//    func handleOrderTap(token: Token?, side: TransactionType) {
//        let token = token ?? counterAsset
//        let vc = OrderController(token: token, side: side)
//        let nav = UINavigationController(rootViewController: vc)
//        self.present(nav, animated: true, completion: nil)
//    }
//
//
//
//}
//
//
//
//extension HoldingsController: PKPaymentAuthorizationControllerDelegate {
//
//    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
//
//    }
//
//
//
//
//}
//
//
