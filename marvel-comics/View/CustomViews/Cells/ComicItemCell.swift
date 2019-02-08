//
//  ComicItemCell.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import Kingfisher

class ComicItemCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var comic: Comic? = nil {
        didSet {
            self.reloadUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coverImageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.coverImageView.image = UIImage(named: "comicPlaceholder")
        self.titleLabel.text = nil
        self.activityIndicator.stopAnimating()
    }
    
    private func reloadUI() {
        self.titleLabel.text = comic?.title
        
        if
            let comicCover = self.comic?.thumbnail,
            let imageUrl = URL(string: "\(comicCover.path).\(comicCover.extension)")
        {
            self.activityIndicator.startAnimating()
            self.coverImageView.kf.setImage(with: imageUrl) { _ in
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
