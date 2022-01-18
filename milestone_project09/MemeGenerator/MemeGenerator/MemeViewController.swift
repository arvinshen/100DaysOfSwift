//
//  MemeViewController.swift
//  MemeGenerator
//
//  Created by Arvin Shen on 1/17/22.
//

import UIKit

class MemeViewController: UIViewController {
    var collectionView: UICollectionView!
    private var images = [UIImage]()
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
    }
}

extension MemeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
}

extension MemeViewController: UICollectionViewDelegate {
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = titles.mainTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: nil, action: nil)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        navigationController?.isToolbarHidden = false
        setToolbarItems([spacer, configureAddButton()], animated: true)
    }
    
    func configureAddButton() -> UIBarButtonItem {
        let compose = UIAction(title: "Online Meme Templates", image: SFSymbol.compose) {
            [weak self] action in
            self?.collectionView.reloadData()
            print("Selected Online Meme Template")
        }
        let camera = UIAction(title: "Camera Photo", image: SFSymbol.camera) {
            [weak self] action in
            self?.collectionView.reloadData()
            print("Selected Camera Photo")
        }
        let photoLibrary = UIAction(title: "Photo Library", image: SFSymbol.photoLibrary) {
            [weak self] action in
            self?.collectionView.reloadData()
            print("Selected Photo Library")
        }
        
        var actions = [UIAction]()
        actions = [photoLibrary, camera, compose]
        let menu = UIMenu(title: "Select Meme Source", image: nil, identifier: nil, options: [], children: actions)
        
        return UIBarButtonItem(title: nil, image: SFSymbol.add, primaryAction: nil, menu: menu)
    }
    
    func configureCollectionView() {
        let view = UIView()
        let margin: CGFloat = 20
        let cellsPerRow = 2
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MemeCell")
        
        let marginsAndInsets = layout.sectionInset.left + layout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + layout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        collectionView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        self.view = view
    }
}
