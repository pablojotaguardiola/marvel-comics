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
    let refreshControl: UIRefreshControl = UIRefreshControl(frame: .zero)
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
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
    }
}

extension ComicListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.comicsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicItemCell.identifier, for: indexPath) as? ComicItemCell,
            let comic = self.viewModel?.getComic(for: indexPath.row)
        else {
            return UICollectionViewCell()
        }
        
        cell.comic = comic
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comicSelected = self.viewModel?.getComic(for: indexPath.row) else { return }
        
        let comicDetailViewModel = ComicDetailViewModel(comic: comicSelected)
        let comicDetailViewController = ComicDetailViewController(viewModel: comicDetailViewModel)
        
        self.navigationController?.pushViewController(comicDetailViewController, animated: true)
    }
}
