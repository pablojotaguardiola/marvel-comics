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
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: ComicItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ComicItemCell.identifier)
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = self.viewModel.getItemSize(for: self.view.frame)
        self.collectionView.collectionViewLayout = collectionViewLayout
        
        self.viewModel.updateComics().startWithResult { _ in
            self.collectionView.reloadData()
        }
        
        self.setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.backgroundColor = .white
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
}
