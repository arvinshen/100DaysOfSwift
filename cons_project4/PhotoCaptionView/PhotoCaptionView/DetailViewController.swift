//
//  DetailViewController.swift
//  PhotoCaptionView
//
//  Created by Arvin Shen on 12/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageCaption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let captionToLoad = imageCaption {
            title = captionToLoad
        }
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(contentsOfFile: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
