//
//  Constants.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import stellarsdk
import Firebase

public struct HorizonServer {
    static let production = ""
    static let test = "https://horizon-testnet.stellar.org/"
    static let url = HorizonServer.test
}

public struct Stellar {
    static let sdk = StellarSDK(withHorizonUrl: HorizonServer.url)
    static let network = Network.testnet
}

var coinbaseURL = "https://api.commerce.coinbase.com"

let db = Firestore.firestore()

let baseAsset = Token.USD
let goldSpotPrice: Decimal = 1400.00

let feeAddress = "GAREM2VSSVKS6L72N3PEK5UPQPLXYEJU6LZVXV3JSFEPBVVZWG2PRRUZ"
