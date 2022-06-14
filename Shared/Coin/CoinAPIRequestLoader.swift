//
//  CoinAPIRequestLoader.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import Foundation
import os

enum CoinAPIRequestLoaderError: Error {
    case invalidResponse, invalidFormat
}

extension CoinAPIRequestLoaderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response (statusCode != 200)"
        case .invalidFormat:
            return "Invalid Format: Cannot convert to CoinResponse"
        }
    }
}

class CoinAPIRequestLoader {
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                                category: String(describing: CoinAPIRequestLoader.self))
    private let apiGetCoinsURLString = "https://api.coinranking.com/v2/coins"
    
    var urlSession: URLSession = URLSession.shared
    
    private func makeGetCoinsRequest(limit: Int, offset: Int, search: String) -> URLRequest {
        let url = URL(string: apiGetCoinsURLString + "?limit=\(limit)&offset=\(offset)&search=\(search)")!
        return URLRequest(url: url)
    }
    
    func loadGetCoinsRequest(limit: Int = 10, offset: Int, search: String = "") async throws -> [Coin] {
        let searchParam = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let request = makeGetCoinsRequest(limit: limit, offset: offset, search: searchParam)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.warning("can't convert response to HTTPURLResponse")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            logger.warning("statusCode != 200, \(httpResponse.statusCode)")
            throw CoinAPIRequestLoaderError.invalidResponse
        }
        do {
            _ = try JSONDecoder().decode(CoinAPIResponse.self, from: data)
        } catch {
            print("\(error)")
        }
        guard let resp = try? JSONDecoder().decode(CoinAPIResponse.self, from: data) else {
            let dataString = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            logger.warning("\(#function) - cannot decode json, \(String(describing: dataString))")
            throw CoinAPIRequestLoaderError.invalidFormat
        }
        return resp.data.coins
    }
}
