//
//  NotesController.swift
//  Notes
//
//  Created by Arvin Shen on 1/8/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class NotesController: UITableViewController, AddNoteControllerDelegate {
    var notes = [Note]()
    var filteredNotes = [Note]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureTableView()
    }
 
    // MARK: - Navigation Controller
    
    private func configureNavigationController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.title = "Notes"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleOptions))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let notesCount = UIBarButtonItem(title: "\(notes.count) Notes", style: .plain, target: nil, action: nil)
        notesCount.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ], for: .normal)
        
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(handleAddNote))
        compose.tintColor = .systemYellow
        setToolbarItems([spacer, notesCount, spacer, compose], animated: true)
        navigationController?.isToolbarHidden = false
    }

    // MARK: - Selectors
    
    @objc func handleAddNote() {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? AddNoteController {
            self.notes.insert(Note(header: "", body: "", text: ""), at: 0)
            vc.index = 0
            vc.textView.text = notes[0].text
            vc.notes = notes
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleOptions() {
        
    }
}

// MARK: - Search Controller

extension NotesController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            if isSearchBarEmpty {
                return false
            } else {
                return note.body.lowercased().contains(searchText.lowercased())
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
    func configureTableView() {
        tableView.layer.cornerRadius = 13
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500)
        ])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let note: Note
        if isFiltering {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        
        if !note.text.isEmpty {
            cell.textLabel?.text = note.header.isEmpty ? "New Note" : note.header
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.detailTextLabel?.text = note.body.isEmpty ? "No additional text" : note.body
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? AddNoteController {
            if isFiltering {
                vc.header = filteredNotes[indexPath.row].header
                vc.body = filteredNotes[indexPath.row].body
                vc.textView.text = filteredNotes[indexPath.row].text
            } else {
                vc.header = notes[indexPath.row].header
                vc.body = notes[indexPath.row].body
                vc.textView.text = notes[indexPath.row].text
            }
            vc.index = indexPath.row
            vc.notes = notes
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func passDataBackToNotesController(header: String, body: String, text: String, index: Int) {
        if text.isEmpty {
            self.notes.remove(at: index)
        } else {
            self.notes[index].header = header
            self.notes[index].body = body
            self.notes[index].text = text
            self.tableView.reloadData()
    //        self.save()
        }
    }
}
