//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Arvin Shen on 11/9/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedPictureNumber = 0
    var totalPictues = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedPictureNumber) of \(totalPictues)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
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
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print ("No image found")
            return
        }
        let watermarkedImage = renderImage(image: image)
        
        let vc = UIActivityViewController(activityItems: [watermarkedImage, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func renderImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let img = renderer.image { ctx in
            let watermark = "From Storm Viewer"
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(white: 0.2, alpha: 0.3),
                .font: UIFont.boldSystemFont(ofSize: 48),
                .paragraphStyle: paragraphStyle,
            ]
            
            let attributedWatermark = NSAttributedString(string: watermark, attributes: attributes)
            
            // draw image first
            image.draw(at: CGPoint(x: 0, y: 0))
            
            // draw text second or else text will be underneath image
            attributedWatermark.draw(with: CGRect(x: 40, y: 40, width: 600, height: 200), options: .usesLineFragmentOrigin, context: nil)
        }
        
        return img
    }
}
