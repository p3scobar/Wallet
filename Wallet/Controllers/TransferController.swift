//
//  TransferController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import UIKit
import stellarsdk
import AudioToolbox
import Foundation

class TransferController: UITableViewController {
    
    var setBackButtonHidden = false {
        didSet {
            self.navigationItem.hidesBackButton = true
        }
    }
    
    var transferCell = "transferCell"
    
    var status: String?
    
    var transfer: Transfer
    
    init(_ transfer: Transfer) {
        self.transfer = transfer
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        let view = UIView(frame: frame)
        var instructionsLabel: UITextView = {
            let view = UITextView(frame: frame)
            view.textContainerInset = UIEdgeInsets(top: 30, left: 12, bottom: 10, right: 12)
            view.backgroundColor = Theme.background
            view.textColor = .black
            view.font = UIFont.boldSystemFont(ofSize: 18)
            view.isEditable = false
            view.text = "Please send bitcoin to the following address. Your deposit will be converted to gold at the daily rate."
            return view
        }()
        view.addSubview(instructionsLabel)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = transfer.type.rawValue.capitalized
        tableView.isScrollEnabled = true
        tableView.allowsSelection = false
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = Theme.background
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(TransferCell.self, forCellReuseIdentifier: transferCell)
        tableView.tableFooterView = footer
        if transfer.type == .deposit {
            tableView.tableHeaderView = header
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    
    init(transfer: Transfer, hideBackButton: Bool) {
        self.transfer = transfer
        super.init(style: .plain)
        self.navigationItem.hidesBackButton = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: transferCell, for: indexPath) as! TransferCell
        setupCell(indexPath: indexPath, cell: cell)
        return cell
    }
    
    func setupCell(indexPath: IndexPath, cell: TransferCell) {
        switch indexPath.row {
        case 0:
            cell.subtitleLeftLabel.text = transfer.currency.uppercased()
            cell.titleLeftLabel.text = transfer.amount
        case 1:
            cell.subtitleLeftLabel.text = "Date"
            cell.titleLeftLabel.text = transfer.timestamp.medium()
        case 2:
            cell.subtitleLeftLabel.text = "Status"
            cell.titleLeftLabel.text = transfer.status.capitalized
        case 3:
            cell.subtitleLeftLabel.text = "Address"
            cell.titleLeftLabel.text = transfer.bitcoinAddress
            cell.titleLeftLabel.numberOfLines = 2
        default:
            break
        }
    }
   
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    lazy var footer: ButtonTableFooterView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        let view = ButtonTableFooterView(frame: frame, title: "Copy Address")
        view.delegate = self
        return view
    }()
    
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    view for section
    
}


extension TransferController: ButtonTableFooterDelegate {
    
    func didTapButton() {
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        self.dismiss(animated: true, completion: nil)
    }
    
    
}



