//
//  ViewController.swift
//  FlagViewer
//
//  Created by Arvin Shen on 11/15/21.
//

import UIKit

class ViewController: UITableViewController {
    var flagFiles = [String]()
    var flags = [String]()
    let suffix = "@3x.png"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(suffix) {
                flagFiles.append(item)
                let temp = String(item.dropLast(suffix.count))
                temp.count == 2 ? flags.append(temp.uppercased()) : flags.append(temp.capitalized)
            }
        }
        
        flagFiles.sort()
        flags.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row]
        cell.imageView?.image = UIImage(named: flagFiles[indexPath.row])
        cell.imageView?.layer.borderWidth = 1.5
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = flagFiles[indexPath.row]
            vc.countryFlag = flags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

