//
//  FavoritesViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 09/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit

class FavoritesViewController: ComicListViewController {
    
    init(viewModel: FavoritesViewModel) {
        super.init(viewModel: viewModel)
        
        self.loadComics()
        
        self.title = "Favorites"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadComics() {
        self.viewModel?.loadComics(reloadList: false).startWithResult { _ in
            self.collectionView.reloadData()
        }
    }
}
