//
//  CoinAPIResponse.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import Foundation

struct CoinAPIResponse: Decodable {
    let status: String
    var data: CoinAPIResponseData
}

struct CoinAPIResponseData: Decodable {
    let coins: [Coin]
}
