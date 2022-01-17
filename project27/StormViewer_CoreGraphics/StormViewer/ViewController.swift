//
//  ViewController.swift
//  StormViewer
//
//  Created by Arvin Shen on 11/8/21.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            do {
                pictures = try JSONDecoder().decode([Picture].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        } else {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(Picture(name: item, viewCount: 0))
                }
            }
            
            pictures.sort(by: {$0.name < $1.name})
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = pictures[indexPath.row].viewCount == 1 ? "\(pictures[indexPath.row].viewCount) view" : "\(pictures[indexPath.row].viewCount) views"
        save()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row].name
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictues = pictures.count
            pictures[indexPath.row].viewCount += 1
            tableView.reloadData()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func save() {
        if let savedData = try? JSONEncoder().encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }
}

