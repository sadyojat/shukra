//
//  CellConfigProtocols.swift
//  Shukra
//
//  Created by Alok Irde on 11/27/21.
//

import UIKit

protocol SimpleCellConfiguration {
    func configureCell(_ text: String?, _ secondaryText: String?, _ image: UIImage?) -> UIListContentConfiguration
}
