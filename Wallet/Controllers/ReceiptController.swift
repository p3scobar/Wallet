//
//  ReceiptController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import UIKit

class ReceiptController: UITableViewController {
    
    let cellId = "cellId"
    var data: [(key: String, value:String)] = []
    
    var walletRefreshDelegate: WalletRefreshDelegate?
    
    init(_ data: [(key: String, value: String)]) {
        self.data = data
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = footer
        tableView.allowsSelection = false
        
        self.navigationItem.title = "Order"
        extendedLayoutIncludesOpaqueBars = true
    }
    
    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        let view = ButtonTableFooterView(frame: frame, title: "Done")
        view.delegate = self
        return view
    }()

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InputTextCell
        cell.valueInput.isEnabled = false
        
        let item = data[indexPath.row]
        cell.textLabel?.text = item.key
        cell.valueInput.text = item.value
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
}


extension ReceiptController: ButtonTableFooterDelegate {
    func didTapButton() {
        if isModal {
            dismiss(animated: true, completion: nil)
            walletRefreshDelegate?.getData(nil)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
}

