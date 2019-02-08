//
//  HomeViewController.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel = HomeViewModel()
    
    // UI Elements
    let collectionView: UICollectionView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.updateComics().startWithResult { _ in
            self.collectionView.reloadData()
        }
        
        self.setupUI()
    }
    
    private func setupUI() {
        
    }
}

