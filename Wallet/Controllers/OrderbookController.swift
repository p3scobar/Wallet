//
//  OrderbookController.swift
//  coins
//
//  Created by Hackr on 1/2/19.
//  Copyright © 2019 Sugar. All rights reserved.
//

import Foundation
import UIKit
import stellarsdk

class OrderbookController: UITableViewController {
    
    var token: Token? = Token.XAU
    
    lazy var header: OrderbookHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120)
        let view = OrderbookHeaderView(frame: frame)
        view.asset = token
        return view
    }()
    
    
    let orderCell = "orderCell"
    
    
    var asks: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var bids: [ExchangeOrder] = [] {
        didSet {
            tableView.reloadData()
            refresh.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrderBook()
        
        refresh.addTarget(self, action: #selector(getOrderBook), for: .valueChanged)
    }

    private let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Order Book"
        tableView.tableHeaderView = header
        tableView.refreshControl = refresh
        refresh.tintColor = Theme.gray
        tableView.backgroundColor = Theme.background
        view.backgroundColor = Theme.background
        
        tableView.register(OrderBookCell.self, forCellReuseIdentifier: orderCell)
        
        extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let send = UIImage(named: "more")?.withRenderingMode(.alwaysTemplate)
        let sendButton = UIBarButtonItem(image: send, style: .done, target: self, action: #selector(handlePending))

        sendButton.tintColor = Theme.black
    }
    
    lazy var footer: OrderButtonView = {
        let frame = CGRect(x: 0, y: self.view.frame.height-120, width: self.view.frame.width, height: 120)
        let view = OrderButtonView(frame: frame)
        view.delegate = self
        return view
    }()
    
    @objc func handlePending() {
        let vc = PendingOrdersController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return asks.count
        } else {
            return bids.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderCell, for: indexPath) as! OrderBookCell
        if indexPath.section == 0 {
            cell.offer = asks[indexPath.row]
        } else {
            cell.offer = bids[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
//    lazy var toolbar: OrderButtonView = {
//        let bottom = self.view.safeAreaInsets.bottom
//        let frame = CGRect(x: 0, y: self.view.frame.height-bottom-80, width: self.view.frame.width, height: 80)
//        let bar = OrderButtonView(frame: frame)
//        return bar
//    }()
    
    @objc func handleBuy() {

    }
    

    @objc func handleSell() {
        
    }
    
    
    @objc func getOrderBook() {
        guard let sell = token else { return }
        let buy = baseAsset
        OrderService.getOrderBook(buy: buy, sell: sell, limit: 5) { (asks, bids) in
            self.asks = asks
            self.bids = bids
            
            asks.forEach({ (ask) in
                print(ask.price)
            })
            let lastPrice = asks.last?.price ?? 0.0
//            self.lastPrice = lastPrice.currency()
            self.header.priceLabel.text = lastPrice.currency(2)
        }
        
//
//        OrderService.getOrderBook(buy: Token.native, sell: baseAsset, limit: 40) { (asks, bids) in
//            self.asks = asks
//            self.bids = bids
//        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var order: ExchangeOrder
        if indexPath.section == 0 {
            order = asks[indexPath.row]
            presentOrderVC(order: order, side: .buy)
        } else {
            order = bids[indexPath.row]
            presentOrderVC(order: order, side: .sell)
        }
    }
    
    func presentOrderVC(order: ExchangeOrder, side: TransactionType) {
//        let counterSide: TransactionType = (side == .buy) ? .sell : .buy
//        let price = order.price
//        guard let token = token else { return }
//        let vc = OrderController(token: token, side: side, size: order.size, price: price)
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Asks"
//        default:
//            return "Bids"
//        }
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let view = SectionHeaderView(frame: frame)
        switch section {
        case 0:
            view.titleLabel.text = "Buy"
        case 1:
            view.titleLabel.text = "Sell"
        default:
            break
        }
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}



extension OrderbookController: OrderButtonDelegate {
    
    func handleOrderTap(side: TransactionType) {
//        let vc = OrderController(token: baseAsset, side: side, size: 0, price: 0)
            //OrderController(token: baseAsset, side: side)
//        let nav = UINavigationController(rootViewController: vc)
//        present(nav, animated: true, completion: nil)
    }
    
}


