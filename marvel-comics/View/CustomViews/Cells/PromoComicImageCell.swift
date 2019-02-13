//
//  PromoComicImageCell.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 14/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import Kingfisher

class PromoComicImageCell: UICollectionViewCell {

    @IBOutlet weak var promoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.promoImageView.image = nil
        self.promoImageView.backgroundColor = .lightGray
        self.activityIndicator.startAnimating()
    }
    
    public func loadImage(comicImage: ComicImage) {
        if let url = comicImage.url {
            self.promoImageView.kf.setImage(with: url) { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.promoImageView.backgroundColor = .clear
            }
        }
    }
}
