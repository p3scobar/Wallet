//
//  UsernameController.swift
//  coins
//
//  Created by Hackr on 12/18/18.
//  Copyright © 2018 Sugar. All rights reserved.
//
//
//import UIKit
//
//class UsernameController: UIViewController {
//
//    let inputCell = "inputCell"
//    var username: String = "" {
//        didSet {
//            print("USERNAME ON CONTROLLER: \(username)")
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = Theme.lightbackground
//        setupView()
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        inputLabel.becomeFirstResponder()
//    }
//
//    lazy var scrollView: UIScrollView = {
//        let view = UIScrollView(frame: self.view.frame)
//        view.alwaysBounceVertical = true
//        view.showsVerticalScrollIndicator = false
//        return view
//    }()
//
//    @objc func handleContinue() {
//        saveUsername()
//        if isModal {
//            let vc = PassphraseController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            print("STring to save: \(username)")
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//
//    func saveUsername() {
//        User.shared.username = username.lowercased()
//    }
//
//    func presentAlert(title: String, message: String?) {
//        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
//        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
//        alert.addAction(done)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//
//    @objc func updateUsername(_ sender: UITextField) {
//        guard let text = sender.text else { return }
//        username = text
//        // TO DO:  check if available in database
//    }
//
//    override var inputAccessoryView: UIView? {
//        return menu
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    static var AllowUserInteraction: UIView.KeyframeAnimationOptions {
//        get {
//            return UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.allowUserInteraction.rawValue)
//        }
//    }
//
//    lazy var titleLabel: UILabel = {
//        let view = UILabel()
//        view.text = "Select a Username"
//        view.font = Theme.medium(24)
//        view.textColor = .black
//        view.textAlignment = .left
//        view.numberOfLines = 2
//        view.lineBreakMode = .byWordWrapping
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var captionLabel: UILabel = {
//        let view = UILabel()
//        let p = OrderService.lastPrice.currency()
//        view.font = Theme.medium(16)
//        view.textColor = .gray
//        view.textAlignment = .left
//        view.numberOfLines = 1
//        view.lineBreakMode = .byWordWrapping
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var menu: UIView = {
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
//        let view = UIView(frame: frame)
//        view.backgroundColor = Theme.lightbackground
//        view.addSubview(inputLabel)
//        view.addSubview(continueButton)
//        return view
//    }()
//
//    lazy var inputLabel: UITextField = {
//        let frame = CGRect(x: 16, y: 20, width: self.view.frame.width-32, height: 44)
//        let view = UITextField(frame: frame)
//        view.font = Theme.medium(18)
//        view.textColor = .black
//        view.backgroundColor = Theme.lightGray
//        view.textAlignment = .center
//        view.autocorrectionType = .no
//        view.autocapitalizationType = .none
//        view.layer.cornerRadius = 12
//        view.text = username
//        view.attributedPlaceholder =
//            NSAttributedString(string: User.shared.username, attributes: [NSAttributedString.Key.foregroundColor: Theme.gray])
//        view.addTarget(self, action: #selector(updateUsername), for: .editingChanged)
//        return view
//    }()
//
//
//    lazy var continueButton: Button = {
//        let frame = CGRect(x: 16, y: 80, width: self.view.frame.width-32, height: 44)
//        let button = Button(frame: frame, title: "Continue")
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = Theme.semibold(18)
//        button.layer.cornerRadius = 12
//        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
//        return button
//    }()
//
//
//    func setupView() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(titleLabel)
//        scrollView.addSubview(captionLabel)
//        scrollView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
//        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
//
//
//        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        captionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
//        captionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//    }
//
//
//    var isModal: Bool {
//        return presentingViewController != nil ||
//            navigationController?.presentingViewController?.presentedViewController === navigationController ||
//            tabBarController?.presentingViewController is UITabBarController
//    }
//
//}



import Foundation
import UIKit

class UsernameController: UITableViewController {
    
    private var username = User.shared.username
    
    let editableCell = "editableCell"
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        let view = UIView(frame: frame)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Username"
        view.backgroundColor = Theme.black
        tableView.backgroundColor = Theme.black
        tableView.separatorColor = Theme.border
        tableView.register(InputTextCell.self, forCellReuseIdentifier: editableCell)
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = save
        tableView.reloadData()
    }
    
    
    @objc func handleSave() {
        User.shared.username = username.lowercased()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: editableCell, for: indexPath) as! InputTextCell
        cell.delegate = self
        cell.key = indexPath.row
        setupCell(cell: cell, indexPath)
        return cell
    }
    
    func setupCell(cell: InputTextCell, _ indexPath: IndexPath) {
        cell.textLabel?.textColor = Theme.gray
        cell.textLabel?.font = Theme.medium(18)
        cell.valueInput.autocapitalizationType = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Username"
            cell.valueInput.text = User.shared.username
            cell.valueInput.placeholder = "@"
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
}



extension UsernameController: InputTextCellDelegate {
    func textFieldDidChange(key: Int, value: String) {
        username = value
    }
}
