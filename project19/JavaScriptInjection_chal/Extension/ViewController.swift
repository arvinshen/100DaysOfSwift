//
//  ViewController.swift
//  Extension
//
//  Created by Arvin Shen on 1/6/22.
//

import UIKit
import MobileCoreServices

class ViewController: UITableViewController, ActionViewControllerDelegate {
    var scripts = [Script]()
    
    var pageTitle = ""
    var pageURL = ""
    var javaScript = ""
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScript))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // extensionContext lets us control how it interacts with the parent app.
        // inputItems will be an array of data the parent app is sending to our extension to use.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                // loadItem asks the item provider to provide us with its item (code executes asynchronously since code uses closure)
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }

                    self?.pageTitle = javaScriptValues["title]"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.load()
                        self?.title = self?.pageTitle
                    }
                }
            }
        }

    }
    
    @objc func addScript() {
        let ac = UIAlertController(title: "Add New Script", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Script Name"
        }
        ac.addTextField { (textField) in
            textField.placeholder = "JavaScript"
        }
                
        let continueAction = UIAlertAction(title: "Continue", style: .default) {
            [weak self, weak ac] _ in
            guard let textFields = ac?.textFields else { return }
            if let name = textFields[0].text, let javaScript = textFields[1].text {
                self?.scripts.insert(Script(name: name, pageTitle: self!.pageTitle, pageURL: self!.pageURL, javaScript: javaScript), at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
        
        ac.addAction(continueAction)
        present(ac, animated: true)
    }
    
    func passDataBackToTableView(data: String, index: Int) {
        // set value to new data and save
        self.scripts[index].javaScript = data
        self.tableView.reloadData()
        self.save()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = scripts[indexPath.row].name
        cell.detailTextLabel?.text = scripts[indexPath.row].javaScript
        save()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Action") as? ActionViewController {
            vc.javaScript = scripts[indexPath.row].javaScript
            vc.scripts = scripts
            vc.index = indexPath.row
            tableView.reloadData()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let site = URL(string: pageURL)

        if let savedScripts = defaults.object(forKey: site?.host ?? "site") as? Data {
            do {
                scripts = try JSONDecoder().decode([Script].self, from: savedScripts)
            } catch {
                print("Failed to load JavaScript")
            }
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        // converts string URL to URL and utilizes URL object host property as forKey
        let site = URL(string: pageURL)

        if let savedScripts = try? JSONEncoder().encode(scripts) {
            // saves user's Scripts for each site by making forKey unique to host
            defaults.set(savedScripts, forKey: site?.host ?? "site")
        } else {
            print("Failed to save JavaScript")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
