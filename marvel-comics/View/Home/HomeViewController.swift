//
//  HomeViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class HomeViewController: ComicListViewController {
    
    public let (setFooterActivityIndicatorStatusSignal, setFooterActivityIndicatorStatusSink) = Signal<Bool, NoError>.pipe()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = HomeViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadFirstComics()
    }
    
    @objc private func loadFirstComics() {
        if self.viewModel?.isGettingComics ?? false {
            return
        }
        
        self.viewModel?.emptyComicList()
        self.collectionView.reloadData()
        self.setFooterActivityIndicatorStatusSink.send(value: true)
        
        self.viewModel?.loadComics(reloadList: true, searchText: self.searchBar.text).startWithResult { _ in
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
            self.setFooterActivityIndicatorStatusSink.send(value: false)
        }
    }
    
    private func loadMoreComics() {
        if self.viewModel?.isGettingComics ?? false {
            return
        }
        
        self.setFooterActivityIndicatorStatusSink.send(value: true)
        
        self.viewModel?.loadComics(reloadList: false, searchText: self.searchBar.text).startWithResult { result in
            self.refreshControl.endRefreshing()
            let newComics = result.value ?? []
            let currentItemsCount = self.collectionView.numberOfItems(inSection: 0)
            let indexPathArray = (currentItemsCount..<(currentItemsCount + newComics.count))
                .map { IndexPath(row: $0, section: 0) }
            self.collectionView.insertItems(at: indexPathArray)
            self.setFooterActivityIndicatorStatusSink.send(value: false)
        }
    }
    
    @objc private func openFavorites() {
        let viewModel = FavoritesViewModel()
        let favViewController = FavoritesViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(favViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.loadMoreComics()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.refreshControl.addTarget(self, action: #selector(loadFirstComics), for: .valueChanged)
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(openFavorites)), animated: false)
    }
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadMoreFooterReusableView.identifier, for: indexPath)
        
        if let loadMoreFooterReusableView = footerView as? LoadMoreFooterReusableView {
            self.setFooterActivityIndicatorStatusSignal.take(until: loadMoreFooterReusableView.reactive.prepareForReuse).observeValues { [weak self] active in
                
                active && !(self?.refreshControl.isRefreshing ?? false)
                    ? loadMoreFooterReusableView.activityIndicator.startAnimating()
                    : loadMoreFooterReusableView.activityIndicator.stopAnimating()
            }
        }
        
        return footerView
    }
}

extension HomeViewController {
    override func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarSearchButtonClicked(searchBar)
        
        self.viewModel?.emptyComicList()
        self.collectionView.reloadData()
        self.loadFirstComics()
    }
    
    override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            super.searchBar(searchBar, textDidChange: searchText)
            self.viewModel?.emptyComicList()
            self.collectionView.reloadData()
            self.loadFirstComics()
        }
    }
}
