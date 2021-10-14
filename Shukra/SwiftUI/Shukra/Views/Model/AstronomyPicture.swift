//
//  AstronomyPicture.swift
//  Shukra
//
//  Created by Alok Irde on 10/12/21.
//

import Foundation
import SwiftUI

struct AstronomyPicture: Hashable, Codable {
    var copyright: String
    var date: String
    var explanation: String
    var hdurl: String
    var media_type: String
    var service_version: String
    var title: String
    var url: String {
        didSet {
//            downloadImage(at: url, completionHandler: nil)
        }
    }
}



