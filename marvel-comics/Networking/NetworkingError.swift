//
//  NetworkingError.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

public enum NetworkingError: Error {
    case unknown
    case parseError
    case error(localized: String)
    
    var rawValue: String {
        switch self {
        case .unknown, .parseError:
            return "error_network_parsing"
            
        case .error(let error):
            return error
        }
    }
}
