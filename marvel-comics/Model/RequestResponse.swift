//
//  RequestResponse.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import Foundation

class RequestResponse<T: Decodable>: Decodable {
    let code: Int
    let data: RequestResponseData<T>?
}

class RequestResponseData<T: Decodable>: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]
}
