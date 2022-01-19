//
//  MemeCell.swift
//  MemeGenerator
//
//  Created by Arvin Shen on 1/17/22.
//

import UIKit

class MemeCell: UICollectionViewCell {
    static let reuseIdentifier = "MemeCell"
    var imageView: UIImageView?
//    var label: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCell() {
        imageView = UIImageView(frame: self.bounds)
        imageView?.layer.cornerRadius = 25
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.clipsToBounds = true
        imageView?.contentMode = .scaleAspectFill
        contentView.addSubview(imageView!)
        
//        label = UILabel(frame: CGRect(x: 10, y: self.bounds.height - 40, width: self.bounds.width - 20, height: 40))
//        label?.text = "Label"
//        label?.textAlignment = .center
//        label?.textColor = .white
//        label?.backgroundColor = UIColor(white: 0, alpha: 0.4)
//        contentView.addSubview(label!)
    }
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}
