//
//  Coin.swift
//  IOS-Networking
//
//  Created by Đoàn Văn Khoan on 03/03/2024.
//

import Foundation

struct Coin : Codable, Identifiable{
    let id : String
    let name : String
    let symbol : String
    let currentPrice : Double
    let marketCapRank : Int
    
    enum CodingKeys : String, CodingKey{
        case id, name, symbol
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
