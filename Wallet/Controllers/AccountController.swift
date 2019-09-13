//
//  AccountController.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import Foundation
import UIKit
import Photos

class AccountController: UITableViewController {
    
    let standardCell = "standardCell"
    
    private var tokens: [Token] = [] {
        didSet {
            tableView.reloadData()
//            tableView.reloadRows(at: [IndexPath(item: 0, section: 2),IndexPath(item: 1, section: 2)], with: .none)
        }
    }
    
    lazy var header: AccountHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280)
        let view = AccountHeaderView(frame: frame)
        view.delegate = self
        return view
    }()

    override init(style: UITableView.Style) {
        super.init(style: style)
        tableView.tableHeaderView = header
        view.backgroundColor = Theme.white
        tableView.backgroundColor = Theme.background
        tableView.separatorColor = Theme.border
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        tableView.showsVerticalScrollIndicator = false
        extendedLayoutIncludesOpaqueBars = true
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 68, bottom: 0, right: 0)
        fetchAssets()
    }

    
    func fetchAssets() {
        WalletService.getAssets { (assets) in
            self.tokens = assets
            assets.forEach({ (asset) in
                print("ASSET CODE: \(asset.assetCode ?? "")")
                print("ASSET BALANCE: \(asset.balance)")
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header.imageUrl = CurrentUser.image
        header.username = CurrentUser.username
        header.name = CurrentUser.name
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
        setupCell(cell: cell, indexPath)
        return cell
    }
    
    func setupCell(cell: StandardCell, _ indexPath: IndexPath) {
        cell.backgroundColor = .white
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.titleLabel.text = "Profile"
            cell.iconView.backgroundColor = Theme.blue
            cell.icon.image = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
        case (0,1):
            cell.titleLabel.text = "Username"
            cell.iconView.backgroundColor = Theme.purple
            cell.icon.image = UIImage(named: "username")?.withRenderingMode(.alwaysTemplate)
        case (1,0):
            cell.titleLabel.text = "Pending Orders"
            cell.iconView.backgroundColor = Theme.green
            cell.icon.image = UIImage(named: "token")?.withRenderingMode(.alwaysTemplate)
        case (2,0):
            cell.titleLabel.text = "Passphrase"
            cell.iconView.backgroundColor = Theme.pink
            cell.icon.image = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
        case (2,1):
            cell.titleLabel.text = "Sign Out"
            cell.iconView.backgroundColor = Theme.red
            cell.icon.image = UIImage(named: "signout")?.withRenderingMode(.alwaysTemplate)
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            pushProfileController()
        case (0,1):
            pushUsernameController()
        case (1,0):
            pushPendingOrdersController()
        case (2,0):
            pushPassphraseController()
        case (2,1):
            promptToSavePassphrase()
        default:
            break
        }
    }
    
    func pushLinkController() {
//        let urlString = "https://cdn.plaid.com/link/v2/stable/link.html"
//        let URL = URL(string: urlString)
//
    }
    
    func pushOrderController(_ side: TransactionType) {
        let vc = OrderController(token: Token.XSG, side: side, size: 0, price: 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentOrderController(_ type: TransactionType) {
        let vc = OrderController(token: baseAsset, side: type, size: 0, price: 0)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func pushProfileController() {
        let vc = ProfileController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushUsernameController() {
        let vc = UsernameController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushPassphraseController() {
        let vc = PassphraseController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushPendingOrdersController() {
        let vc = PendingOrdersController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func promptToSavePassphrase() {
        let alert = UIAlertController(title: "Backup Passphrase", message: "Have you backed up your passphrase? It is the only way to recover your account.", preferredStyle: .alert)
        let done = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (signout) in
            self.handleLogout()
        }
        alert.addAction(done)
        alert.addAction(signOut)
        present(alert, animated: true, completion:  nil)
    }
    
    func handleLogout() {
        WalletService.logOut {
            let vc = HomeController()
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}


extension AccountController: AccountHeaderDelegate {
    
    func handleImageTap() {
        presentImagePickerController()
    }
    
    
}


extension AccountController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func photoPermission() -> Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        var authorized: Bool = false
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            authorized = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    authorized = true
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
            authorized = false
        case .denied:
            print("User has denied the permission.")
            authorized =  false
        }
        return authorized
    }
    
    
    func presentImagePickerController() {
        if photoPermission() {
            let vc = UIImagePickerController()
            vc.allowsEditing = true
            vc.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = pickedImage as? UIImage
        }
        if let resizedImage = selectedImageFromPicker {
            let image = resizedImage.resized(toWidth: 800)
            UserService.updateProfilePic(image: image) { (imageUrl) in
                CurrentUser.image = imageUrl
            }
            DispatchQueue.main.async {
                self.header.profileImageView.image = selectedImageFromPicker
                self.tableView.reloadData()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension AccountController: UIGestureRecognizerDelegate {
    
}
