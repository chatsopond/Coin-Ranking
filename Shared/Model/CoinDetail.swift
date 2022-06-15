//
//  CoinDetail.swift
//  LMWN Coin 2
//
//  Created by Chatsopon Deepateep on 15/6/2565 BE.
//

import Foundation

struct CoinDetail: Decodable {
    let uid = UUID()
    var uuid: String?
    var description: String
    var websiteUrl: URL?
    
    /// Identifiable variable
    var id: String { uuid ?? uid.uuidString }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    
    private enum CodingKeys: String, CodingKey {
        case description, websiteUrl
    }
    
    init(
        description: String,
        websiteUrl: URL?
    ) {
        self.description = description
        self.websiteUrl = websiteUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let description = (try? container.decode(String.self, forKey: .description)) ?? "No Description"
        var websiteUrl: URL?
        if let websiteUrlString = try? container.decode(String.self, forKey: .websiteUrl) {
            websiteUrl = URL(string: websiteUrlString)
        }
        self.init(
            description: description,
            websiteUrl: websiteUrl)
    }
}
