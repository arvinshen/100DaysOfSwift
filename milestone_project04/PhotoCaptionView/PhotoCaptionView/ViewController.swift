//
//  ViewController.swift
//  PhotoCaptionView
//
//  Created by Arvin Shen on 12/24/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo Caption"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(capturePhoto))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(uploadPhoto))
        
        let defaults = UserDefaults.standard
        
        if let savedPhotos = defaults.object(forKey: "photos") as? Data {
            do { photos = try JSONDecoder().decode([Photo].self, from: savedPhotos) }
            catch { print("Failed to load photos") }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as? PhotoCell else {
            fatalError("Unable to dequeue PhotoCell.")
        }
        
        let photo = photos[indexPath.row]
        
        cell.caption.text = photo.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(photo.name)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView?.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.cornerRadius = 5
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let path = getDocumentsDirectory().appendingPathComponent(photos[indexPath.row].name)
            vc.selectedImage = path.path
            vc.imageCaption = photos[indexPath.row].caption
            tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func capturePhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func uploadPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let photo = Photo(name: imageName, caption: "Caption this photo")
        photos.append(photo)
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Add a caption to this photo", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) {
                [weak self, weak ac] _ in
                guard let newCaption = ac?.textFields?[0].text else { return }
                photo.caption = newCaption
                self?.save()
                self?.tableView.reloadData()
            })
            self.present(ac, animated: true)
        }
        tableView.reloadData()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        if let savedData = try? JSONEncoder().encode(photos) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "photos")
        } else { print("Failed to save photos") }
    }
}

