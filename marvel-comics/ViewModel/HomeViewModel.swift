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
    
    private var comics: [Comic] = []
    
    public var comicsCount: Int {
        return comics.count
    }
    
    public func updateComics() -> SignalProducer<Void, NetworkingError> {
        return Networking().get(type: RequestResponse<Comic>.self, operation: .getComicList).on { requestResponse in
            self.comics = requestResponse.data?.results ?? []
        }.map { _ in return () }
    }
    
    public func getComic(for index: Int) -> Comic? {
        guard index < self.comics.count else { return nil }
        
        return self.comics[index]
    }
    
    public func getItemSize(for frame: CGRect) -> CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGSize(width: (frame.width / 2.0) - 10, height: 250)
        case .pad:
            return CGSize(width: (frame.width / 3.0) - 10, height: 300)
        case .unspecified, .tv, .carPlay:
            return CGSize(width: (frame.width / 2.0) - 10, height: 200)
        }
    }
}
