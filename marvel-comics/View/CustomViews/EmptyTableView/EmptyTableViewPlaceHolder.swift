//
//  EmptyTableViewPlaceHolder.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit
import SnapKit

class EmptyTableViewPlaceHolder: UIView {
    
    private let mainIcon: UIImageView
    private let titleLabel: UILabel
    private let subtitleLabel: UILabel

    init(imageNamed: String, title: String?, subtitle: String?) {
        self.mainIcon = UIImageView(image: UIImage(named: imageNamed))
        self.titleLabel = UILabel(frame: .zero)
        self.subtitleLabel = UILabel(frame: .zero)
        
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = false
        self.isOpaque = false
        
        self.addSubview(self.mainIcon)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subtitleLabel)
        
        self.mainIcon.snp.makeConstraints { make in
            make.height.width.equalTo(120)
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.mainIcon.snp.bottom).offset(16)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
        
        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
        
        self.mainIcon.contentMode = .scaleAspectFit
        
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
        
        self.subtitleLabel.text = subtitle
        self.subtitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.subtitleLabel.textColor = .white
        self.subtitleLabel.numberOfLines = 0
        self.subtitleLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    public func setSubtitle(subtitle: String) {
        self.subtitleLabel.text = subtitle
    }
}
