//
//  HomeViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel = HomeViewModel()
    
    // UI Elements
    let backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "backgroundHeroes"))
    let refreshControl: UIRefreshControl = UIRefreshControl(frame: .zero)
    let bottomRefreshControl: UIRefreshControl = UIRefreshControl(frame: .zero)
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshControl.beginRefreshing()
        self.loadFirstComics()
        
        self.bottomRefreshControl.beginRefreshing()
    }
    
    @objc private func loadFirstComics() {
        if self.viewModel.isDownloadingComics {
            return
        }
        
        self.viewModel.downloadComics(reloadList: true).startWithResult { _ in
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func loadMoreComics() {
        if self.viewModel.isDownloadingComics {
            return
        }
        
        self.viewModel.downloadComics(reloadList: false).startWithResult { result in
            self.refreshControl.endRefreshing()
            let newComics = result.value ?? []
            let currentItemsCount = self.collectionView.numberOfItems(inSection: 0)
            let indexPathArray = (currentItemsCount..<(currentItemsCount + newComics.count))
                .map { IndexPath(row: $0, section: 0) }
            self.collectionView.insertItems(at: indexPathArray)
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .lightGray
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.collectionView)
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.refreshControl.tintColor = .white
        self.refreshControl.addTarget(self, action: #selector(loadFirstComics), for: .valueChanged)
        
        self.collectionView.refreshControl = self.refreshControl
        self.collectionView.addSubview(self.bottomRefreshControl)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.footerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 50.0)
        collectionViewLayout.itemSize = self.viewModel.getItemSize(for: self.view.frame)
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UINib.init(nibName: ComicItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ComicItemCell.identifier)
        self.collectionView.register(UINib.init(nibName: LoadMoreFooterReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: LoadMoreFooterReusableView.identifier)
        
        self.backgroundImageView.contentMode = .scaleAspectFill
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.comicsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicItemCell.identifier, for: indexPath) as? ComicItemCell else {
            return UICollectionViewCell()
        }
        
        cell.comic = self.viewModel.getComic(for: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comicSelected = self.viewModel.getComic(for: indexPath.row) else { return }
        
        let comicDetailViewModel = ComicDetailViewModel(comic: comicSelected)
        let comicDetailViewController = ComicDetailViewController(viewModel: comicDetailViewModel)
        
        self.navigationController?.pushViewController(comicDetailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.loadMoreComics()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadMoreFooterReusableView.identifier, for: indexPath)
        
        return view
    }
}
