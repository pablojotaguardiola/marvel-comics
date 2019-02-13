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

class HomeViewModel: NSObject, ComicListViewModelProtocol {
    
    internal var comics: MutableProperty<[Comic]> = MutableProperty([])
    
    internal var isGettingComics: Bool = false
    
    /**
     Download comics and add them to the existing list
     Parameters:
     - reloadList: if this is true, existing comic list will be emptied
     
     Returns a SignalProducer with the new downloaded comics
     */
    public func loadComics(reloadList: Bool, searchText: String?) -> SignalProducer<[Comic], NetworkingError> {
        self.isGettingComics = true
        let offset = reloadList ? 0 : self.comics.value.count
        if reloadList {
            self.comics.value = []
        }
        
        return Networking().get(type: RequestResponse<Comic>.self, operation: .getComicList(offset: offset, searchText: searchText)).on { requestResponse in
            self.comics.value.append(contentsOf: requestResponse.data?.results ?? [])
            self.isGettingComics = false
        }.map { requestResponse in
            return requestResponse.data?.results ?? []
        }
    }
}
