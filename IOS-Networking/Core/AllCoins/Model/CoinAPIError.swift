//
//  CoinAPIError.swift
//  IOS-Networking
//
//  Created by Đoàn Văn Khoan on 03/03/2024.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description : String)
    case invalidStatusCode(statusCode : String)
    case unknownError(error : Error)
    
    var customDescription : String {
        switch self {
        case .invalidData: return "Invalid Data"
        case .jsonParsingFailure: return "Failed to parse JSON"
        case let .requestFailed(description): return "Request Failed : \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid Status Code : \(statusCode)"
        case let .unknownError(error): return "An Unknown Error : \(error)"
        }
    }
}
