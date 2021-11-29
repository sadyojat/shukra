//
//  MRGroupedListViewController.swift
//  Shukra
//
//  Created by Alok Irde on 11/28/21.
//

import UIKit

class MRGroupedListViewController: UIViewController {

    let sectionHeaderElementKind = "section-header-element-kind"
    
    var dataSource: UICollectionViewDiffableDataSource<String, Photo>! = nil
    var collectionView: UICollectionView! = nil
    
    //MARK: Rover specific variables
    let scopeButtonTitles = ["Curiosity", "Spirit", "Opportunity"]
    var cache = [String: RoverPhotos]()
    var imageCache = [String: UIImage]()
    var currentDataSet = [String: [Photo]]()
    var currentSections = [String]()
    var selectedRover: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        configureViewHierarchy()
        configureDataSource()
    }
}

//MARK: Initial View Layout and configurations
extension MRGroupedListViewController /* Initial Configuration */ {
    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44.0))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
                                                                        elementKind: sectionHeaderElementKind,
                                                                        alignment: NSRectAlignment.top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureViewHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    
    func configureSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.scopeButtonTitles = scopeButtonTitles
        search.searchBar.showsScopeBar = true
        search.delegate = self
        navigationItem.searchController = search
        navigationItem.title = "Grouped Fixed CL List"
        selectedRover = scopeButtonTitles[search.searchBar.selectedScopeButtonIndex]
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration <GroupedListCell, Photo>{ [self] cell, indexPath, photo in
            if let image = self.imageCache[photo.imageUrl] {
                if let photos = self.currentDataSet[currentSections[indexPath.section]], indexPath.row == photos.count-1 {
                    cell.configureContent(photo.rover.name+" "+photo.camera.name, photo.camera.fullName+" \(photo.id)", image, true)
                } else {
                    cell.configureContent(photo.rover.name+" "+photo.camera.name, photo.camera.fullName+" \(photo.id)", image)
                }                
            } else {
                Task {
                    do {
                        let image = try await MRNetworkInteractor().fetchImage(photo.imageUrl)
                        self.imageCache[photo.imageUrl] = image
                        self.applyUpdatedSnapshot(with: photo)
                    } catch {
                        print("ERROR: image download failed for url \(photo.imageUrl)")
                    }
                }
            }
        }
        
        let sectionHeaderRegistration = UICollectionView.SupplementaryRegistration<SectionTitleSupplementaryView>(elementKind: sectionHeaderElementKind) { supplementaryView, string, indexPath in
            supplementaryView.label.text = self.currentSections[indexPath.section]
            supplementaryView.backgroundColor = .systemGroupedBackground
        }
        
        dataSource = UICollectionViewDiffableDataSource<String, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: photo)
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, string, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderRegistration, for: indexPath)
        }
        fetchAndApplyInitialSnapshot()
    }
}

//MARK: Snapshots Data Manager
extension MRGroupedListViewController {
    func fetchAndApplyInitialSnapshot() {
        let roverName = selectedRover.lowercased()
        if let roverPhotos = cache[roverName] {
            preprocessData(for: roverPhotos)
            applyInitialSnapshot()
        } else {
            Task {
                do {
                    let roverPhotos = try await MRNetworkInteractor().fetchPhotos(roverName)
                    preprocessData(for: roverPhotos)
                    applyInitialSnapshot()
                } catch {
                    print("ERROR:: Could not retrieve photos for \(roverName)")
                }
            }
        }
    }
    
    func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Photo>()
        currentSections.forEach { sectionIdentifier in
            if let photos = currentDataSet[sectionIdentifier] {
                snapshot.appendSections([sectionIdentifier])
                snapshot.appendItems(photos, toSection: sectionIdentifier)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func applyUpdatedSnapshot(with photo: Photo) {
        var updatedSnapshot = self.dataSource.snapshot()
        updatedSnapshot.reloadItems([photo])
        self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
    }
}

extension MRGroupedListViewController {
    func preprocessData(for roverPhotos: RoverPhotos) {
        let photos = roverPhotos.photos
        currentDataSet = [String: [Photo]]()
        currentSections = [String]()
        for photo in photos {
            let key = photo.camera.fullName
            if var list = currentDataSet[key] {
                list.append(photo)
                currentDataSet[key] = list
            } else {
                currentDataSet[key] = [photo]
                currentSections.append(key)
            }
        }
    }
}

//MARK: Search Results handling
extension MRGroupedListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = searchController.searchBar.text else {
            return
        }
        selectedRover = scopeButtonTitles[searchController.searchBar.selectedScopeButtonIndex]
//        updatePlaceholder(searchController)
        fetchAndApplyInitialSnapshot()
    }
}

//MARK: Collection View Delegate handlers
extension MRGroupedListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
