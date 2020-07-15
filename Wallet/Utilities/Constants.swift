//
//  Constants.swift
//  coins
//
//  Created by Hackr on 12/6/18.
//  Copyright © 2018 Sugar. All rights reserved.
//

import stellarsdk

public struct HorizonServer {
    static let production = "https://horizon.stellar.org"
    static let test = "https://horizon-testnet.stellar.org"
    static let url = HorizonServer.test
}

public struct Stellar {
    static let sdk = StellarSDK(withHorizonUrl: HorizonServer.url)
    static let network = Network.testnet
}


var counterAsset = Token.XAU
var baseAsset = Token.USD

public var merchantID: String = "merchant.delemont.bullion"

var paymentServiceURL = "https://fund.bubbleapps.io/version-test/api/1.1/wf/"

var stripePk = "pk_test_WDfUQO5NEUSDMFk8sQylAmLF00MEfpxOVh"

var dbURL = "https://fund.bubbleapps.io/version-test/api/1.1/wf/"

var cards: [String: PaymentMethod] = [:]

var defaultPaymentMethod: PaymentMethod = PaymentMethod()

var plans: [String: Plan] = [:]
