//
//  ComicListViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 09/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import SnapKit

class ComicListViewController: UIViewController {
    
    var viewModel: ComicListViewModelProtocol? = nil
    
    // UI Elements
    let backgroundImageView: UIImageView = UIImageView(image: UIImage(named: "backgroundHeroes"))
    var emptyCollectionViewPlaceHolder: EmptyTableViewPlaceHolder = EmptyTableViewPlaceHolder(imageNamed: "WaitIcon", title: "No results", subtitle: "Please wait or reload.")
    let refreshControl: UIRefreshControl = UIRefreshControl(frame: .zero)
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let searchBar = UISearchBar(frame: .zero)
    
    init(viewModel: ComicListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    open func setupUI() {
        self.searchBar.delegate = self
        
        self.view.backgroundColor = .lightGray
        
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.emptyCollectionViewPlaceHolder)
        self.view.addSubview(self.collectionView)
        
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.emptyCollectionViewPlaceHolder.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.emptyCollectionViewPlaceHolder.isHidden = true
        
        self.searchBar.placeholder = "Start with title..."
        self.searchBar.barTintColor = UIColor(red: 237.0/255.0, green: 29.0/255.0, blue: 36.0/255.0, alpha: 1.0)
        self.refreshControl.tintColor = .white
        
        self.collectionView.refreshControl = self.refreshControl
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.footerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 50.0)
        collectionViewLayout.itemSize = self.viewModel?.getItemSize(for: self.view.frame) ?? .zero
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UINib.init(nibName: ComicItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ComicItemCell.identifier)
        self.collectionView.register(UINib.init(nibName: LoadMoreFooterReusableView.identifier, bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: LoadMoreFooterReusableView.identifier)
        
        self.backgroundImageView.contentMode = .scaleAspectFill
        
        self.viewModel?.comics.producer.on(value: { [weak self] comics in
            DispatchQueue.main.async {
                self?.emptyCollectionViewPlaceHolder.isHidden = comics.count != 0
            }
        }).start()
    }
}

extension ComicListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.comicsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicItemCell.identifier, for: indexPath)
        
        if
            let comicCell = cell as? ComicItemCell,
            let comic = self.viewModel?.getComic(for: indexPath.row)
        {
            comicCell.comic = comic
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comicSelected = self.viewModel?.getComic(for: indexPath.row) else { return }
        
        let comicDetailViewModel = ComicDetailViewModel(comic: comicSelected)
        let comicDetailViewController = ComicDetailViewController(viewModel: comicDetailViewModel)
        
        self.navigationController?.pushViewController(comicDetailViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

extension ComicListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.resignFirstResponder()
    }
}
