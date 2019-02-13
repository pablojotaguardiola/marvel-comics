//
//  FavoritesViewModel.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 09/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class FavoritesViewModel: NSObject, ComicListViewModelProtocol {
    
    internal var comics: MutableProperty<[Comic]> = MutableProperty([])
    
    var isGettingComics: Bool = false
    
    /**
     Load comics from CoreData and update the list
     */
    public func loadComics(reloadList: Bool = false, searchText: String?) -> SignalProducer<[Comic], NetworkingError> {
        self.isGettingComics = true
        
        return SignalProducer { observer, _ in
            DispatchQueue.global(qos: .background).async {
                
                if
                    let searchText = searchText,
                    !searchText.isEmpty
                {
                    self.comics.value = Comic.getAll(withTitleLike: searchText)
                }
                else {
                    self.comics.value = Comic.getAll()
                }
                
                DispatchQueue.main.async {
                    observer.send(value: self.comics.value)
                }
                
                self.isGettingComics = false
            }
        }
    }
}
