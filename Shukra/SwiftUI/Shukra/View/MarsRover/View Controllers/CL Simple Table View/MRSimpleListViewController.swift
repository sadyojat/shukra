//
//  MRSimpleListViewController.swift
//  Shukra
//
//  Created by Alok Irde on 11/27/21.
//

import UIKit

class MRSimpleListViewController: UITableViewController {

    var dataSource: UITableViewDiffableDataSource<MRSection, Photo>! = nil
    
    let scopeButtonTitles = ["Curiosity", "Spirit", "Opportunity"]
    
    var cache = [String: RoverPhotos]()
    var imageCache = [String: UIImage]()
    
    var selectedRover: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simple-list-mr-cell")
        configureHierarchy()
        configureDataSource()
        // Do any additional setup after loading the view.
    }
}


extension MRSimpleListViewController: SimpleCellConfiguration {
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

extension MRSimpleListViewController {
    func configureHierarchy() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.scopeButtonTitles = scopeButtonTitles
        search.searchBar.showsScopeBar = true
        search.delegate = self
        navigationItem.searchController = search
        navigationItem.title = "Simple CL List"
        selectedRover = scopeButtonTitles[search.searchBar.selectedScopeButtonIndex]
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<MRSection, Photo>(tableView: tableView, cellProvider: { [self] tableView, indexPath, photo in
            let cell = tableView.dequeueReusableCell(withIdentifier: "simple-list-mr-cell", for: indexPath)
            if let image = imageCache[photo.imageUrl] {
                cell.contentConfiguration = configureCell(photo.rover.name, photo.camera.fullName+" \(photo.id)", image)
            } else {
                Task {
                    do {
                        let image = try await MRNetworkInteractor().fetchImage(photo.imageUrl)
                        imageCache[photo.imageUrl] = image
                        applyUpdatedSnapshot(with: photo)
                    } catch {
                        print("ERROR: failed image download")
                    }
                }
                
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        self.dataSource.defaultRowAnimation = .fade
        reload()
    }
}


extension MRSimpleListViewController /* Manage Initial & Updated snapshots */ {
    func applyInitialSnapshot(with photos: [Photo]) {
        var initialSnapshot = NSDiffableDataSourceSnapshot<MRSection, Photo>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(photos)
        self.dataSource.apply(initialSnapshot, animatingDifferences: true)
    }
    
    func applyUpdatedSnapshot(with photo: Photo) {
        var updatedSnapshot = self.dataSource.snapshot()
        updatedSnapshot.reloadItems([photo])
        self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
    }
}

extension MRSimpleListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = searchController.searchBar.text else {
            return
        }
        selectedRover = scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
        updatePlaceholder(searchController)
        reload()
    }
}

extension MRSimpleListViewController: UISearchControllerDelegate {
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


extension MRSimpleListViewController /* Private functions */{
    private func reload() {
        let roverName = selectedRover.lowercased()
        if let roverPhotos = cache[roverName] {
            applyInitialSnapshot(with: roverPhotos.photos)
        } else {
            Task {
                do {
                    let roverPhotos = try await MRNetworkInteractor().fetchPhotos(roverName)
                    cache[roverName] = roverPhotos
                    applyInitialSnapshot(with: roverPhotos.photos)
                } catch {
                    print("ERROR :: roverPhotos unavailable")
                }
            }
        }
    }
}
