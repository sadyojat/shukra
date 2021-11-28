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
