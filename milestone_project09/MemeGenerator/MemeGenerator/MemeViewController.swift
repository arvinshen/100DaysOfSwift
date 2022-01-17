//
//  MemeViewController.swift
//  MemeGenerator
//
//  Created by Arvin Shen on 1/17/22.
//

import UIKit

class MemeViewController: UIViewController, UICollectionViewDelegate {
    var collectionView: UICollectionView?
    private var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MemeCell")
        collectionView?.backgroundColor = .systemBlue
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        view.addSubview(collectionView ?? UICollectionView())
        
        self.view = view
    }
}

extension MemeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath)
        cell.backgroundColor = .systemRed
        return cell
    }
}
