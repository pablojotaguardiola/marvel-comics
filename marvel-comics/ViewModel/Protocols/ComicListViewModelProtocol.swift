//
//  ComicListProtocol.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 09/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol ComicListViewModelProtocol {
    var comics: MutableProperty<[Comic]> { get set }
    var isGettingComics: Bool { get set }
    
    func loadComics(reloadList: Bool, searchText: String?) -> SignalProducer<[Comic], NetworkingError>
    mutating func emptyComicList()
}

extension ComicListViewModelProtocol {
    
    var comicsCount: Int {
        return comics.value.count
    }
    
    public func getComic(for index: Int) -> Comic? {
        guard index < self.comics.value.count else { return nil }
        
        return self.comics.value[index]
    }
    
    public func getItemSize(for frame: CGRect) -> CGSize {
        if Device.isPad {
            return CGSize(width: (frame.width / 3.0) - 10, height: 300)
        }
        
        return CGSize(width: (frame.width / 2.0) - 10, height: 250)
    }
    
    public mutating func emptyComicList() {
        self.comics.value = []
    }
}
