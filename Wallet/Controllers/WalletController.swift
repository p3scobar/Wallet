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
    
    let paymentCell = "paymentCell"
    
    var payments: [Payment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var header: WalletHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 290)
        let view = WalletHeaderView(frame: frame)
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        
        tableView.backgroundColor = Theme.white
        view.backgroundColor = Theme.white
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(auth), name: Notification.Name(rawValue: "login"), object: nil)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let account = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        let accountButton = UIBarButtonItem(image: account, style: .done, target: self, action: #selector(handleAccountTap))
        accountButton.tintColor = Theme.gray
        self.navigationItem.leftBarButtonItem = accountButton
        
        let send = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        let sendButton = UIBarButtonItem(image: send, style: .done, target: self, action: #selector(handleSendTap))
        sendButton.tintColor = Theme.gray
        self.navigationItem.rightBarButtonItem = sendButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleQRScan), name: Notification.Name("scan"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin), name: Notification.Name("login"), object: nil)
        
        if let drawer = self.parent?.parent as? PulleyViewController {
            drawer.delegate = self
        }
        
        auth()
    }
    
    
    @objc func handleLogin() {
        getAssets()
        fetchPayments()
        streamPayments()
    }
    
    @objc func handleSendTap() {
        let vc = UsersController(token: Token.GOLD)
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
        let vc = NewAmountController(publicKey)
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
//            handleLoggedOut()
            presentLoginView()
            return
        }
        if CurrentUser.uuid == "" {
            UserService.getCurrentUser()
        }
        getAssets()
        fetchPayments()
        streamPayments()
    }
    
    func presentLoginView() {
//            let background = UIView(frame: CGRect(x: 20, y: 200, width: self.view.frame.width-40, height: 54))
//        background.backgroundColor = Theme.selected
//        tableView.backgroundView = background
    }
    
    func getAssets() {
        WalletService.getAccountDetails { (assets) in
            guard let token = assets.filter({ $0.assetCode == "GOLD" }).first else { return }
            self.header.token = token
        }
    }
    
    func fetchPayments() {
        WalletService.fetchPayments { (payments) in
            self.payments = payments
        }
    }
    
    func streamPayments() {
        WalletService.streamPayments { (payment) in
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

    
}


extension WalletController: WalletHeaderDelegate {
    func handleQRTap() {
        definesPresentationContext = true
        let vc = QRController()
        vc.modalTransitionStyle = .crossDissolve
        let nav = UINavigationController(rootViewController: vc)
        if let pulley = parent?.parent as? PulleyViewController {
            pulley.present(nav, animated: true, completion: nil)
        }
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
