//
//  MRNetworkInteractor.swift
//  Shukra
//
//  Created by Alok Irde on 11/22/21.
//

import Foundation
import UIKit

let photosUrl = "https://api.nasa.gov/mars-photos/api/v1/rovers/${rovername}/photos"

let roverUrls = [
    "curiosity": "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=\(apiKey)",
    "opportunity": "https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?sol=1000&api_key=\(apiKey)",
    "spirit": "https://api.nasa.gov/mars-photos/api/v1/rovers/spirit/photos?sol=1000&api_key=\(apiKey)"
]

struct MRNetworkInteractor {
    func fetchPhotos(_ roverName: String) async throws -> RoverPhotos {
        guard let roverUrl = roverUrls[roverName.lowercased()], let url = URL(string: roverUrl) else {
            throw CustomError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
        return try JSONDecoder().decode(RoverPhotos.self, from: data)
    }
    
    func fetchImage(_ imageUrl: String) async throws -> UIImage {
        guard let url = URL(string: imageUrl) else {
            throw CustomError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
        
        if let image = UIImage(data: data) {
            return image
        } else {
            throw CustomError.failedImageDecode
        }
    }
}
