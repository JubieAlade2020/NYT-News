//
//  APIError.swift
//  NYT-News
//
//  Created by Jubie Alade on 2/16/22.
//

import Foundation

/// API errors that may occur when fetching data.
enum APIError: Error {
    case noKeyProvided
    case rateLimitReached
    case defaultError
}

extension APIError {
    public var errorCode: Int {
        switch self {
        case .noKeyProvided:
            return 401
        case .rateLimitReached:
            return 429
        case .defaultError:
            return 1
        }
    }
}
