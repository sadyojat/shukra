//
//  MarsRoverViewController.swift
//  Shukra
//
//  Created by Alok Irde on 11/8/21.
//

import UIKit
import SwiftUI




struct MarsRover: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MarsRoverViewController {
        let vc = MarsRoverViewController(style: .plain)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MarsRoverViewController, context: Context) {
    
    }
    
    typealias UIViewControllerType = MarsRoverViewController
}

class MarsRoverViewController: UITableViewController {
    
    let viewOptions = [
        "Simple Table View",
        "Composition Layout Table View",
        "Collection View",
        "Composition Layout Collection View"
    ]
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ViewOptionCell")
        tableView.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newCell: UITableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ViewOptionCell") {
            newCell = cell
        } else {
            newCell = UITableViewCell(style: .default, reuseIdentifier: "ViewOptionCell")
        }
        
        var content = newCell.defaultContentConfiguration()
        content.text = viewOptions[indexPath.row]
        content.image = UIImage(systemName: "star.fill")
        newCell.contentConfiguration = content
        newCell.accessoryType = .disclosureIndicator
        
        return newCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewOptions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(MRSimpleTableViewController(style: .plain), animated: true)
        default:
            break
        }
    }
}


//class MarsRoverViewController: UIViewController {
//    private var collectionView: UICollectionView! = nil
//    private var dataSource: UICollectionViewDiffableDataSource<Int, RoverPhoto>! = nil
//    private var snapshot: NSDiffableDataSourceSnapshot<Int, RoverPhoto>! = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createHierarchy()
//        createDataSource()
//    }
//}
//
//extension MarsRoverViewController {
//    func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .absolute(44.0))
//
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(10.0)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 10.0
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
//
////        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
////                                                      heightDimension: .estimated(44.0))
////        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
////                                                                        elementKind: "date-header",
////                                                                        alignment: .top)
////        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize,
////                                                                        elementKind: "date-footer",
////                                                                        alignment: .bottom)
////        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
//
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//}
//
//
//extension MarsRoverViewController: UICollectionViewDelegate {
//
//}
//
//extension MarsRoverViewController {
//    func createHierarchy() {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.addSubview(collectionView)
//        collectionView.delegate = self
//    }
//
//    func createDataSource() {
//        let cellRegistration = UICollectionView.CellRegistration<MRListCell, RoverPhoto> { cell, indexPath, photo in
//            cell.configureLabel(with: photo.rover.name)
//        }
//
//        dataSource = UICollectionViewDiffableDataSource<Int, RoverPhoto>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: photo)
//            return cell
//        })
//
//
//        snapshot = NSDiffableDataSourceSnapshot<Int, RoverPhoto>()
//        let sections = Array(0..<1)
//        sections.forEach {
//            snapshot.appendSections([$0])
//            snapshot.appendItems([
//                RoverPhoto(),
//                RoverPhoto()
//            ])
//        }
//
//        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
//
//
//    }
//}
