//
//  ComicDetailViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import Kingfisher
import ReactiveCocoa

class ComicDetailViewController: UIViewController {
    
    public let viewModel: ComicDetailViewModel
    
    // UI Elements
    let headerBackground: UIImageView
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    let favButton: UIButton
    let pageCountLabel: UILabel
    let promoImagesCollectionView: PGCollectionView

    init(viewModel: ComicDetailViewModel) {
        self.viewModel = viewModel
        
        self.headerBackground = UIImageView(frame: .zero)
        self.titleLabel = UILabel(frame: .zero)
        self.descriptionLabel = UILabel(frame: .zero)
        self.favButton = UIButton(frame: .zero)
        self.pageCountLabel = UILabel(frame: .zero)
        self.promoImagesCollectionView = PGCollectionView(title: "Promo images:", itemSize: CGSize(width: 150, height: 150), scrollOrientation: .horizontal(numOfRows: 1))
        self.promoImagesCollectionView.collectionView.register(UINib.init(nibName: PromoComicImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: PromoComicImageCell.identifier)
        
        super.init(nibName: nil, bundle: nil)
        
        self.promoImagesCollectionView.collectionView.dataSource = self
        
        self.setupUI()
        self.loadComicInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func favButtonPressed() {
        self.viewModel.toggleFavorites()
        self.reloadFavButton()
    }
    
    private func loadComicInfo() {
        self.title = self.viewModel.comic.title
        self.titleLabel.text = self.viewModel.comic.title
        self.descriptionLabel.text = self.viewModel.comic.descriptionText
        self.pageCountLabel.text = self.viewModel.comic.pageCount > 0 ? "(\(self.viewModel.comic.pageCount) pages)" : ""
        
        if let thumbnailUrl = self.viewModel.comic.thumbnail?.url {
            self.headerBackground.kf.setImage(with: thumbnailUrl)
        }
        
        self.reloadFavButton()
        self.promoImagesCollectionView.reloadData()
    }
    
    private func reloadFavButton() {
        self.favButton.setTitle(self.viewModel.favButtonTitle(), for: .normal)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.headerBackground)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.favButton)
        self.view.addSubview(self.pageCountLabel)
        self.view.addSubview(self.promoImagesCollectionView)
        
        self.headerBackground.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(Device.isPad ? 250 : 150)
            make.width.equalTo(self.headerBackground.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.headerBackground.snp.right).offset(16)
            make.top.equalTo(self.headerBackground)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        self.pageCountLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        self.favButton.snp.makeConstraints { make in
            make.left.equalTo(self.headerBackground.snp.right).offset(16)
            make.top.equalTo(self.pageCountLabel.snp.bottom).offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.headerBackground.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.promoImagesCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(16)
        }
        
        self.headerBackground.layer.cornerRadius = 10
        self.headerBackground.clipsToBounds = true
        self.headerBackground.contentMode = .scaleAspectFill
        self.headerBackground.image = UIImage(named: "comicPlaceholder")
        
        self.titleLabel.numberOfLines = 2
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: Device.isPad ? .title1 : .title3)
        
        self.descriptionLabel.numberOfLines = 5
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: Device.isPad ? .body : .footnote)
        
        self.favButton.setTitleColor(.blue, for: .normal)
        
        self.pageCountLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.favButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.favButtonPressed()
        }
        
        self.promoImagesCollectionView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.promoImagesCollectionView.layer.borderWidth = 1.0
    }
}

extension ComicDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getComicImagesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoComicImageCell.identifier, for: indexPath) as? PromoComicImageCell,
            let comicImage = self.viewModel.getComicImage(at: indexPath.row)
        else {
            return UICollectionViewCell()
        }
        
        cell.loadImage(comicImage: comicImage)
        
        return cell
    }
}
