//
//  MRSimpleTableViewController.swift
//  Shukra
//
//  Created by Sadyojat on 11/22/21.
//

import UIKit

let vanillaSearch: String = "Search..."


class MRSimpleTableViewController: UITableViewController {
    let scopeButtonTitles = ["Curiosity", "Spirit", "Opportunity"]
    
    var cache = [String: RoverPhotos]()
    var imageCache = [String: UIImage]()
    
    var selectedRover: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.scopeButtonTitles = scopeButtonTitles
        search.searchBar.showsScopeBar = true
        search.delegate = self
        navigationItem.searchController = search
        navigationItem.title = "Simple Table View"
        selectedRover = scopeButtonTitles[search.searchBar.selectedScopeButtonIndex]
        updatePlaceholder(search)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simple-tv-mr-cell")
        reload()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let roverPhotos = cache[selectedRover], roverPhotos.photos.count > 0 else {
            return 0
        }
        return roverPhotos.photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simple-tv-mr-cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        if let roverPhotos = cache[selectedRover], roverPhotos.photos.count > indexPath.row  {
            let photoInfo = roverPhotos.photos[indexPath.row]
            if let image = imageCache[photoInfo.imageUrl] {
                cell.contentConfiguration = configureCell(photoInfo.rover.name, photoInfo.camera.fullName+" \(photoInfo.id)", image)
            } else {
                Task {
                    do {
                        let image = try await MRNetworkInteractor().fetchImage(photoInfo.imageUrl)
                        self.imageCache[photoInfo.imageUrl] = image
                        if let cell = tableView.cellForRow(at: indexPath) {
                            cell.contentConfiguration = configureCell(photoInfo.rover.name, photoInfo.camera.fullName+" \(photoInfo.id)", image)
                        }
                    } catch {
                        print("ERROR: failed image download")
                    }
                }
            }
        } else {
            cell.contentConfiguration = configureCell(nil, nil, nil)
        }
        return cell
    }
    
        
}

extension MRSimpleTableViewController: SimpleCellConfiguration {
    func configureCell(_ text: String?, _ secondaryText: String?, _ image: UIImage?) -> UIListContentConfiguration {
        var config = UIListContentConfiguration.subtitleCell()
        config.imageProperties.maximumSize = CGSize(width: 44.0, height: 44.0)
        config.imageProperties.cornerRadius = 3.0
        config.text = text
        config.secondaryText = secondaryText
        config.image = image
        return config
    }
}


extension MRSimpleTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = searchController.searchBar.text else {
            return
        }
        selectedRover = scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
        updatePlaceholder(searchController)
        reload()
    }
}


extension MRSimpleTableViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsScopeBar = false
        updatePlaceholder(searchController)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsScopeBar = true
        updatePlaceholder(searchController)
    }
    
    private func updatePlaceholder(_ searchController: UISearchController, with vanillaSearchText: String? = nil) {
        if let vanillaSearchText = vanillaSearchText {
            searchController.searchBar.placeholder = vanillaSearchText
        } else {
            searchController.searchBar.placeholder = "\(selectedRover) rover search..."
        }
    }
}


extension MRSimpleTableViewController /* Private functions */{
    private func reload() {
        let roverName = selectedRover.lowercased()
        if cache[selectedRover] == nil {
            Task {
                do {
                    cache[selectedRover] = try await MRNetworkInteractor().fetchPhotos(roverName)
                    tableView.reloadData()
                } catch {
                    print("ERROR :: roverPhotos unavailable")
                }
            }
        } else {
            tableView.reloadData()
        }
    }
}
