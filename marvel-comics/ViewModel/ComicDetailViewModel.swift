//
//  ComicDetailViewModel.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import Foundation

class ComicDetailViewModel: NSObject {
    
    let comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
        
        super.init()
    }
    
    public func favButtonTitle() -> String {
        return Comic.exists(id: self.comic.id)
            ? "Remove from favorites"
            : "Add to favorites"
    }
    
    public func toggleFavorites() {
        if let comic: Comic = Comic.get(by: self.comic.id) {
            comic.delete()
        }
        else {
            self.comic.insertIfNeeded()
        }
        
        CoreData.save()
    }
    
    public func getComicImagesCount() -> Int {
        return self.comic.images?.count ?? 0
    }
    
    public func getComicImage(at index: Int) -> ComicImage? {
        guard
            let comicImagesSet = self.comic.images,
            let comicImages = Array(comicImagesSet) as? [ComicImage],
            index < comicImages.count
        else {
            return nil
        }
        
        return comicImages[index]
    }
}
