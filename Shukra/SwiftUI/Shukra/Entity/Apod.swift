//
//  Apod.swift
//  Shukra
//
//  Created by Sadyojat on 10/12/21.
//

import Foundation
import SwiftUI

struct Apod: Hashable, Codable, Identifiable {
    var copyright: String?
    var date: String?
    var explanation: String?
    var hdurl: String?
    var media_type: String?
    var service_version: String?
    var title: String
    var url: String
    var id: UUID {
        UUID()
    }
}


final class ApodService: ObservableObject {
    private let urlString = "https://api.nasa.gov/planetary/apod?api_key="+apiKey
    func load() async throws -> Apod {
        do {
            let data = try await NetworkInteractor.fetchAsyncLoad(url: urlString)
            let picture = try JSONDecoder().decode(Apod.self, from: data)
            return picture
        } catch {
            print("ERROR \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadImage(_ imageurl: URL) async throws -> Image {
        return try await NetworkInteractor.fetchAsyncImage(imageurl)
    }
    
    func loadWithContinuation() async throws -> Apod {
        let picture: Apod = try await withCheckedThrowingContinuation({ continuation in
            fetchPODData { pictureOrNil, errorOrNil in
                if let error = errorOrNil {
                    continuation.resume(throwing: error)
                } else if let picture = pictureOrNil {
                    continuation.resume(returning: picture)
                }
            }
        })
        return picture
    }
        
    private func fetchPODData(_ completionHandler: @escaping(Apod?, Error?) -> Void) {        
        NetworkInteractor.load(url: urlString) { dataOrNil, errorOrNil in
            if let error = errorOrNil {
                return completionHandler(nil, error)
            }
            
            if let data = dataOrNil {
                do {
                    let picture = try JSONDecoder().decode(Apod.self, from: data)
                    completionHandler(picture, nil)
                } catch {
                    completionHandler(nil, CustomError.failedDecode)
                }
            }
        }
    }
}




