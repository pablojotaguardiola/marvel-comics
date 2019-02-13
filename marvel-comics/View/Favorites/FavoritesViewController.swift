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
        
        // Setup UI
        self.title = "Favorites"
        self.refreshControl.addTarget(self, action: #selector(loadComics), for: .valueChanged)
        
        // Customize empty placeholder
        self.emptyCollectionViewPlaceHolder.setTitle(title: "No comics yet")
        self.emptyCollectionViewPlaceHolder.setSubtitle(subtitle: "Add some comics to this list to check them later")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func loadComics() {
        self.viewModel?.loadComics(reloadList: false, searchText: self.searchBar.text).startWithResult { _ in
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension FavoritesViewController {
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarSearchButtonClicked(searchBar)
        
        self.loadComics()
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            super.searchBar(searchBar, textDidChange: searchText)
            
            self.loadComics()
        }
    }
}
