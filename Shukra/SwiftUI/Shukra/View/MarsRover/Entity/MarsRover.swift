//
//  MarsRover.swift
//  Shukra
//
//  Created by Alok Irde on 11/22/21.
//

import Foundation


struct Rover: Codable {
    enum CodingKeys: String, CodingKey {
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case id, name, status
    }
    
    var id: Int
    var name: String
    var landingDate: String
    var launchDate: String
    var status: String
}

struct Camera: Codable {
    var id: Int
    var name: String
    var roverId: Int
    var fullName: String

    enum CodingKeys: String, CodingKey {
        case roverId = "rover_id"
        case fullName = "full_name"
        case id, name
    }
}

struct Photo: Codable {
    var id: Int
    var solarDay: Int
    var earthDate: String
    var imageUrl: String
    var rover: Rover
    var camera: Camera

    enum CodingKeys: String, CodingKey {
        case imageUrl = "img_src"
        case solarDay = "sol"
        case earthDate = "earth_date"
        case id, rover, camera
    }
}

struct RoverPhotos: Codable {
    var photos: [Photo]
}
