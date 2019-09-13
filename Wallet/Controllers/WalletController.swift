//
//  ViewController.swift
//  coins
//
//  Created by Hackr on 12/5/18.
//  Copyright © 2018 Sugar. All rights reserved.
//


import UIKit
import Pulley

class WalletController: UITableViewController {
    
    let refresh = UIRefreshControl()
    let paymentCell = "paymentCell"
    private var token: Token? {
        didSet {
            
        }
    }
    
    var payments: [Payment] = [] {
        didSet {
            tableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    lazy var header: WalletHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
        let view = WalletHeaderView(frame: frame)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = refresh
        tableView.tableHeaderView = header
        extendedLayoutIncludesOpaqueBars = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        
        tableView.backgroundColor = Theme.background
        view.backgroundColor = Theme.background
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(auth), name: Notification.Name(rawValue: "login"), object: nil)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        let account = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        let accountButton = UIBarButtonItem(image: account, style: .done, target: self, action: #selector(handleAccountTap))
        accountButton.tintColor = Theme.gray
        self.navigationItem.leftBarButtonItem = accountButton

        
        let send = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        let sendButton = UIBarButtonItem(image: send, style: .done, target: self, action: #selector(handleSendTap))
        sendButton.tintColor = Theme.gray
        self.navigationController?.navigationBar.barTintColor = Theme.background
        self.navigationItem.rightBarButtonItems = [sendButton]
        NotificationCenter.default.addObserver(self, selector: #selector(handleQRScan), name: Notification.Name("scan"), object: nil)
        
        if let drawer = self.parent?.parent as? PulleyViewController {
            drawer.delegate = self
            drawer.drawerTopInset = 10
        }
        refresh.addTarget(self, action: #selector(getData), for: .valueChanged)
        checkAuthentication()
    }
    
    func checkAuthentication() {
        guard KeychainHelper.publicKey != "" else {
            presentAuthController()
            return
        }
        getData(nil)
        streamPayments()
    }
    
    @objc func getData(_ refresh: UIRefreshControl?) {
        getPayments()
        getAssets()
    }
    
    func presentAuthController() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }

    
    @objc func handleSendTap() {
        let vc = UsersController(token: Token.XSG)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true, completion: nil)
    }
    
    
    @objc func handleQRScan(_ notification: Notification) {
        openDrawer()
        if let code = notification.userInfo?["code"] as? String {
            pulleyViewController?.setDrawerPosition(position: .open, animated: true)
            pushAmountController(code)
        }
    }
    
    
    func pushAmountController(_ publicKey: String) {
        let vc = AmountController(publicKey: publicKey, type: .send)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func handleAccountTap() {
        openDrawer()
        let vc = AccountController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Passphrase: \(KeychainHelper.mnemonic)")
        print("Public Key: \(KeychainHelper.publicKey)")
        print("Secret Key: \(KeychainHelper.privateSeed)")
        getAssets()
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
        if CurrentUser.uuid == "" {
            UserService.getCurrentUser()
        }
    }
    
    
    @objc func getAssets() {
        WalletService.getAccountDetails { (token) in
            self.header.token = token
            self.token = token
            self.refresh.endRefreshing()
            self.header.setupValues()
        }
    }
    
    
    func getPayments() {
        WalletService.fetchPayments { (payments) in
            self.payments = payments
        }
    }
    
    
    func streamPayments() {
        WalletService.streamPayments { (payment) in
            SoundKit.playSound(type: .receive)
            self.payments.insert(payment, at: 0)
            self.getAssets()
        }
    }
    
    
    func handleLoggedOut() {
        let vc = HomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false, completion: nil)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
        cell.payment = payments[indexPath.row]
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let payment = payments[indexPath.row]
        let vc = PaymentController(payment: payment)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeader
    }
    
    lazy var sectionHeader: UITextView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40 )
        let view = UITextView(frame: frame)
        view.text = "Transactions"
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0);
        view.font = Theme.bold(24)
        view.backgroundColor = Theme.background
        return view
    }()
    

    
}


extension WalletController: WalletHeaderDelegate {
    
    func handleQRTap() {
        let QR = QRController()
        let nav = UINavigationController(rootViewController: QR)
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    
    func handleCardTap() {
        handleQRTap()
    }
    
    func handleBuy() {
        presentOrderController(.buy)
    }
    
    func handleSell() {
        presentOrderController(.sell)
    }
    
    func presentOrderController(_ type: TransactionType) {
        let vc = OrderController(token: Token.XSG, side: type, size: 0, price: 0)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
}


extension WalletController: PulleyDrawerViewControllerDelegate {
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        if drawer.drawerPosition == PulleyPosition.open {
            self.tableView.isScrollEnabled = true
        } else {
            self.tableView.isScrollEnabled = false
        }
        if drawer.drawerPosition != PulleyPosition.open {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    func openDrawer() {
        if let pulley = self.parent?.parent as? PulleyViewController {
            pulley.setDrawerPosition(position: .open, animated: true)
        }
    }
    
    
   
    
}
