//
//  NotesController.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class NotesController: UITableViewController {
    var notes = [Note]()
    var filteredNotes = [Note]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        configureNavigationController()
        configureTabBarController()
    }
    
    // MARK: - Navigation Controller
    private func configureNavigationController() {
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Notes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleAddNote))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    // MARK: - Tab Bar Controller

    func configureTabBarController() {
        navigationController?.tabBarItem.title = "\(notes.count) Notes"
        navigationController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        tabBarController?.tabBar.barTintColor = .black
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.tintColor = .systemYellow
//        tabBarController?.viewControllers?.append(self)
//            .tabBarItem.image = UIImage.init(named: "square.and.pencil")
    }
    
    // MARK: - Selectors
    
    @objc func handleAddNote() {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? AddNoteController {
//            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - Search Controller

extension NotesController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFilter: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            if isSearchBarEmpty {
                return false
            } else {
                return note.text.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: - UITableView

extension NotesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].firstLine
        cell.detailTextLabel?.text = notes[indexPath.row].text
        return cell
    }
}
