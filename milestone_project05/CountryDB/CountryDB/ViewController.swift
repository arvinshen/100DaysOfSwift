//
//  ViewController.swift
//  CountryDB
//
//  Created by Arvin Shen on 1/1/22.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()
    var filteredCountries = [Country]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CountryDB"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        performSelector(onMainThread: #selector(fetchJSON), with: nil, waitUntilDone: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc func fetchJSON() {
        if let fileURL = Bundle.main.url(forResource: "country", withExtension: ".json") {
            if let data = try? Data(contentsOf: fileURL) {
                DispatchQueue.global(qos: .userInitiated).async {
                    [weak self] in
                    self?.parse(json: data)
                }
                return
            }
        }
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonData = try? decoder.decode(Countries.self, from: json) {
            countries = jsonData.countries
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter { (country: Country) -> Bool in
            if isSearchBarEmpty {
                return false
            } else {
                return country.country.lowercased().contains(searchText.lowercased()) || country.abbreviation.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
        }
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        
        cell.textLabel?.text = country.country
        cell.detailTextLabel?.text = country.abbreviation
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            if isFiltering {
                vc.detailItem = filteredCountries[indexPath.row]
            } else {
                vc.detailItem = countries[indexPath.row]
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

