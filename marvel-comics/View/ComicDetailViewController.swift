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
    
    let viewModel: ComicDetailViewModel
    
    // UI Elements
    let headerView: UIView
    let bodyView: UIView
    let headerBackground: UIImageView
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    let favButton: UIButton

    init(viewModel: ComicDetailViewModel) {
        self.viewModel = viewModel
        
        self.headerView = UIView(frame: .zero)
        self.bodyView = UIView(frame: .zero)
        self.headerBackground = UIImageView(frame: .zero)
        self.titleLabel = UILabel(frame: .zero)
        self.descriptionLabel = UILabel(frame: .zero)
        self.favButton = UIButton(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
        
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
        self.titleLabel.text = self.viewModel.comic.title
        self.descriptionLabel.text = self.viewModel.comic.descriptionText
        
        if let thumbnailUrl = self.viewModel.comic.thumbnailUrl {
            self.headerBackground.kf.setImage(with: thumbnailUrl)
        }
        
        self.reloadFavButton()
    }
    
    private func reloadFavButton() {
        self.favButton.setTitle(self.viewModel.favButtonTitle(), for: .normal)
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.bodyView)
        self.view.addSubview(self.headerBackground)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.descriptionLabel)
        self.view.addSubview(self.favButton)
        
        // - Header
        
        self.headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        self.headerBackground.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(32)
            make.left.equalToSuperview().offset(32)
            make.height.equalTo(250)
            make.width.equalTo(self.headerBackground.snp.height).multipliedBy(2.0 / 3.0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.headerBackground.snp.right).offset(16)
            make.top.equalTo(self.headerBackground)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
        
        self.favButton.snp.makeConstraints { make in
            make.left.equalTo(self.headerBackground.snp.right).offset(16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.headerBackground.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        // - Body
        
        self.bodyView.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.headerView.clipsToBounds = true
        
        self.headerBackground.layer.cornerRadius = 10
        self.headerBackground.clipsToBounds = true
        self.headerBackground.contentMode = .scaleAspectFill
        self.headerBackground.image = UIImage(named: "comicPlaceholder")
        
        self.titleLabel.numberOfLines = 2
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        
        self.descriptionLabel.numberOfLines = 5
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        self.favButton.setTitleColor(.blue, for: .normal)
        
        self.favButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.favButtonPressed()
        }
    }
}
