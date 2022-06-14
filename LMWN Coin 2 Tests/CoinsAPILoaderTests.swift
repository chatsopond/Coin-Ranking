//
//  CoinsAPILoaderTests.swift
//  LMWN Coin 2 Tests
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import XCTest
@testable import LMWN_Coin_2

class CoinsAPILoaderTests: XCTestCase {
    
    var sut: CoinAPIRequestLoader!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoinAPIRequestLoader()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        sut.urlSession = urlSession
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetSingleCoins() async {
        // Given
        let limit = 1
        let offset = 0
        let mockJson = JsonLoader.stringFrom(
            for: type(of: self),
            forResource: "coins-limit-1-offset-1")
            .data(using: .utf8)!
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockJson)
        }
        
        // When
        let coins = try! await sut.loadGetCoinsRequest(limit: limit, offset: offset)
        
        // Then
        XCTAssertNotNil(coins)
    }

}
