//
//  MenuItem.swift
//  Shukra
//
//  Created by Sadyojat on 10/17/21.
//

import Foundation

struct MenuItem: Hashable, Codable, Identifiable {
    var id: String
    var description: String
    var isFavorite: Bool? = true
}
