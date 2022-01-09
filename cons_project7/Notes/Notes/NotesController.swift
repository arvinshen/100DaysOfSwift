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
        viewWillAppearNavigationControllerSettings()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureNavigationController()
        configureTabBarController()
        configureTableView()
    }
 
    // MARK: - Navigation Controller
    
    private func configureNavigationController() {
        navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.title = "Notes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(handleAddNote))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func viewWillAppearNavigationControllerSettings() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    // MARK: - Tab Bar Controller

    func configureTabBarController() {
        navigationController?.tabBarItem.title = "\(notes.count) Notes"
        navigationController?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -15)
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.tintColor = .systemYellow
        tabBarController?.tabBar.clipsToBounds = true
//        tabBarController?.viewControllers?.append(self)
//            .tabBarItem.image = UIImage.init(named: "square.and.pencil")
    }
    
    // MARK: - Selectors
    
    @objc func handleAddNote() {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? AddNoteController {
            self.notes.insert(Note(firstLine: "", text: ""), at: 0)
            vc.index = 0
            vc.textView.text = notes[0].text
            vc.notes = notes
            vc.delegate = self
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
    func configureTableView() {
        tableView.layer.cornerRadius = 13
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].firstLine
        cell.detailTextLabel?.text = notes[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Note") as? AddNoteController {
            vc.index = indexPath.row
            vc.textView.text = notes[indexPath.row].text
            vc.notes = notes
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func passDataBackToNotesController(data: String, index: Int) {
        if data.isEmpty {
            self.notes.remove(at: index)
        } else {
            self.notes[index].text = data
            self.tableView.reloadData()
    //        self.save()
        }
    }
}

//extension UINavigationController {
//    func configureStatusBar(backgroundColor: UIColor) {
//        let statusBarFrame: CGRect
//        if #available(iOS 13.0, *) {
//            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//        } else {
//            statusBarFrame = UIApplication.shared.statusBarFrame
//        }
//        let statusBarView = UIView(frame: statusBarFrame)
//        statusBarView.backgroundColor = backgroundColor
//        view.addSubview(statusBarView)
//    }
//}

// MARK: - DARK MODE (Future Implementation)

//        navigationController?.navigationBar.barTintColor = .black
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

//        tabBarController?.tabBar.barTintColor = .black


//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}

// MARK: - Status Bar

//    var isDarkContentBackground = false

//    func statusBarEnterLightBackground() {
//        isDarkContentBackground = false
//        setNeedsStatusBarAppearanceUpdate()
//    }
//
//    func statusBarEnterDarkBackground() {
//        isDarkContentBackground = true
//        setNeedsStatusBarAppearanceUpdate()
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if isDarkContentBackground {
//            return .lightContent
//        } else {
//            return .darkContent
//        }
//    }
    
//    private func configureStatusBar(backgroundColor: UIColor) {
//        let statusBarFrame: CGRect
//        if #available(iOS 13.0, *) {
//            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//        } else {
//            statusBarFrame = UIApplication.shared.statusBarFrame
//        }
//        let statusBarView = UIView(frame: statusBarFrame)
//        statusBarView.backgroundColor = backgroundColor
//        view.addSubview(statusBarView)
//
//        if #available(iOS 13.0, *) {
//            let app = UIApplication.shared
//            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
//
//            let statusBarView = UIView()
//            statusBarView.backgroundColor = .white
//            view.addSubview(statusBarView)
//
//            statusBarView.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                statusBarView.heightAnchor.constraint(equalToConstant: statusBarHeight),
//                statusBarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
//                statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
//                statusBarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            ])
//        } else {
//            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//            statusBar?.backgroundColor = .white
//        }
//        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
//        statusBarView.backgroundColor = .white
//    }
