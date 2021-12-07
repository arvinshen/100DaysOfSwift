//
//  ViewController.swift
//  ShoppingList
//
//  Created by Arvin Shen on 12/5/21.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearList))
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareOnTapped))
        navigationItem.rightBarButtonItems = [add, share]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item to list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        if !isEmpty(item: answer) {
            if !isDuplicate(item: answer) {
                shoppingList.append(answer)
                let indexPath = IndexPath(row: shoppingList.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                showConfirmationMessage(confirmTitle: "\(answer) is already in the list", confirmMessage: "Do you want to add it again?", item: answer)
            }
        } else {
            showErrorMessage(errorTitle: "Blank Response", errorMessage: "Nothing was added to the list")
        }
    }
    
    @objc func shareOnTapped() {
        let list = shoppingList.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func isEmpty(item: String) -> Bool {
        return item.count == 0
    }
    
    func isDuplicate(item: String) -> Bool {
        return shoppingList.contains(item)
    }

    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showConfirmationMessage(confirmTitle: String, confirmMessage: String, item: String) {
        let ac = UIAlertController(title: confirmTitle, message: confirmMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) {
            [weak self] _ in
            self?.shoppingList.append(item)
            let indexPath = IndexPath(row: (self?.shoppingList.count)! - 1, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        let cancelAction = UIAlertAction(title: "No", style: .default)
        
        ac.addAction(confirmAction)
        ac.addAction(cancelAction)
        ac.preferredAction = cancelAction
        
        present(ac, animated: true)
    }
}

