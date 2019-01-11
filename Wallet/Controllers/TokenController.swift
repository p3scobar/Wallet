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
    let paymentCell = "paymentCell"
    
    lazy var header: TokenHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 220)
        let view = TokenHeaderView(frame: frame, token: token)
        view.token = self.token
        view.delegate = self
        return view
    }()
    
    init(_ token: Token) {
        self.token = token
        super.init(style: .grouped)
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.separatorColor = Theme.border
        tableView.tableHeaderView = header
        self.navigationItem.title = token.assetCode ?? ""
        getLastPrice()
    }
    
    func getLastPrice() {
        TokenService.getLastPrice(token: token) { (price) in
            self.header.priceLabel.text = price
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
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.register(PaymentCell.self, forCellReuseIdentifier: paymentCell)
        
        let send = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        let sendButton = UIBarButtonItem(image: send, style: .done, target: self, action: #selector(handleSendTap))
        
        let scan = UIImage(named: "qrcode")?.withRenderingMode(.alwaysTemplate)
        let scanButton = UIBarButtonItem(image: scan, style: .done, target: self, action: #selector(handleScanTap))
        self.navigationItem.setRightBarButtonItems([scanButton, sendButton], animated: false)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return payments.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
            if indexPath.row == 0 {
                cell.textLabel?.text = "About"
            } else {
                cell.textLabel?.text = "Order Book"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: paymentCell, for: indexPath) as! PaymentCell
            cell.payment = payments[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64
        } else {
            return 84
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pushTokenDescriptionController()
        case (0,1):
            pushOrderbookController()
        default:
            break
        }
    }
    
    func pushTokenDescriptionController() {
        let vc = TokenAboutController(description: token.description)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushOrderbookController() {
        let vc = OrderbookController(token)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleScanTap() {
        let vc = ScanController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func handleSendTap() {
        let vc = UsersController(token: token)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



extension TokenController: TokenHeaderDelegate {
    
    func handleOrderTap(token: Token, side: TransactionType) {
        let vc = OrderController(token: token, side: side)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
