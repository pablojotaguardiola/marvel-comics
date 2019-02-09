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
    
    public private(set) var isDownloadingComics: Bool = false
    
    /**
     Download comics and add them to the existing list
     Parameters:
     - reloadList: if this is true, existing comic list will be emptied
     
     Returns a SignalProducer with the new downloaded comics
     */
    public func downloadComics(reloadList: Bool) -> SignalProducer<[Comic], NetworkingError> {
        self.isDownloadingComics = true
        let offset = reloadList ? 0 : self.comics.count
        if reloadList {
            self.comics = []
        }
        
        return Networking().get(type: RequestResponse<Comic>.self, operation: .getComicList(offset: offset)).on { requestResponse in
            self.comics.append(contentsOf: requestResponse.data?.results ?? [])
            self.isDownloadingComics = false
        }.map { requestResponse in
            return requestResponse.data?.results ?? []
        }
    }
    
    public func getComic(for index: Int) -> Comic? {
        guard index < self.comics.count else { return nil }
        
        return self.comics[index]
    }
    
    public func getItemSize(for frame: CGRect) -> CGSize {
        if Device.isPad {
            return CGSize(width: (frame.width / 3.0) - 10, height: 300)
        }
        
        return CGSize(width: (frame.width / 2.0) - 10, height: 250)
    }
}
