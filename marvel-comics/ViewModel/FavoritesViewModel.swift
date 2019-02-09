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
    
    internal var comics: [Comic] = []
    
    var isGettingComics: Bool = false
    
    /**
     Load comics from CoreData and update the list
     */
    public func loadComics(reloadList: Bool = false) -> SignalProducer<[Comic], NetworkingError> {
        self.isGettingComics = true
        
        return SignalProducer { observer, _ in
            DispatchQueue.global(qos: .background).async {
                
                self.comics = Comic.getAll()
                
                DispatchQueue.main.async {
                    observer.send(value: self.comics)
                }
                
                self.isGettingComics = false
            }
        }
    }
}
