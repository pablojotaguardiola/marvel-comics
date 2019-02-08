//
//  HomeViewModel.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class HomeViewModel: NSObject {
    
    private(set) var comics: [Comic] = []
    
    public func updateComics() -> SignalProducer<Void, NetworkingError> {
        return Networking().get(type: RequestResponse<Comic>.self, operation: .getComicList).on { requestResponse in
            self.comics = requestResponse.data?.results ?? []
        }.map { _ in return () }
    }
}
