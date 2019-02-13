//
//  PGCollectionView.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit

/*
 Custom class that contains a collection view that is defined by direction and
 number of rows or columns.
 */
class PGCollectionView: UIView {
    
    private let titleLabel: UILabel
    public let collectionView: UICollectionView
    
    enum ScrollOrientation {
        case horizontal(numOfRows: Int)
        case vertical(numOfColumns: Int)
    }
    
    private let title: String
    private let itemSize: CGSize
    private let scrollOrientation: ScrollOrientation
    
    init(title: String, itemSize: CGSize, scrollOrientation: ScrollOrientation) {
        self.title = title
        self.itemSize = itemSize
        self.scrollOrientation = scrollOrientation
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        switch scrollOrientation {
        case .vertical(_):
            flowLayout.scrollDirection = .vertical
        case .horizontal(_):
            flowLayout.scrollDirection = .horizontal
        }
        
        self.titleLabel = UILabel(frame: .zero)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.collectionView)
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            switch self.scrollOrientation {
            case .vertical(let numOfColumns):
                make.width.equalTo((self.itemSize.width + 1) * CGFloat(numOfColumns) + 1)
            
            case .horizontal(let numOfRows):
                make.height.equalTo((self.itemSize.height + 1) * CGFloat(numOfRows) + 1)
            }
        }

        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.45, alpha: 1)
        self.titleLabel.text = self.title.uppercased()
        
        self.collectionView.backgroundColor = UIColor.clear
    }
}
