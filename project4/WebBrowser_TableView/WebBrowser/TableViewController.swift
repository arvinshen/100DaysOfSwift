//
//  TableViewController.swift
//  WebBrowser
//
//  Created by Arvin Shen on 11/17/21.
//

import UIKit
import WebKit

class TableViewController: UITableViewController, WKNavigationDelegate {
    var websites = ["google.com", "apple.com", "hackingwithswift.com", "old.reddit.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Top Sites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteName", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            vc.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
