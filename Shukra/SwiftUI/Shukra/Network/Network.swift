//
//  ModelData.swift
//  Shukra
//
//  Created by Sadyojat on 10/12/21.
//

import Foundation
import SwiftUI

enum CustomError: Error {
    case failedDownload
    case invalidResponse
    case failedDecode
    case invalidURL
    case failedImageDecode
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failedDownload:
            return "Error in download, please retry"
        case .invalidResponse:
            return "Invalid http response code"
        case .failedDecode:
            return "JSON decoding failed"
        case .invalidURL:
            return "Invalid URL"
        case .failedImageDecode:
            return "Image decoding failed"
        }
    }
}

private let apiKey = "QpaRwg94lcrw75Befex6xRahvMdwbypgZa2MtROY"

struct NetworkInteractor {
            
    static func fetchImage(_ imageURL: URL, completionHandler: @escaping(Image?, Error?)->()) {
        let downloadTask = URLSession.shared.downloadTask(with: imageURL) { fileURLOrNil, responseOrNil, errorOrNil in
            if let error = errorOrNil {
                completionHandler(nil, error)
            }
            
            if let fileURL = fileURLOrNil {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let image = Image(uiImage: UIImage(data: data)!)
                    completionHandler(image, nil)
                } catch {
                    completionHandler(nil, error)
                }
            } else {
                completionHandler(nil, CustomError.failedDownload)
            }
        }
        downloadTask.resume()
    }
    
    static func fetchPODData(_ completionHandler: @escaping(Apod?, Error?) -> Void) {
        let urlString = "https://api.nasa.gov/planetary/Apod?api_key="+apiKey
        load(url: urlString) { dataOrNil, errorOrNil in
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
    
    private static func load(url path: String, completionHandler: ((Data?, Error?)->Void)?) {
        guard let url = URL(string: path) else {
            completionHandler?(nil, CustomError.invalidURL)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { dataOrNil, responseOrNil, errorOrNil in
            if let _ = errorOrNil {
                completionHandler?(nil, CustomError.failedDownload)
            }
            guard let response = responseOrNil as? HTTPURLResponse,
               (200...299).contains(response.statusCode) else {
                   completionHandler?(nil, CustomError.invalidResponse)
                   return
            }
            
            if let data = dataOrNil {
                completionHandler?(data, nil)
            } else  {
                completionHandler?(nil, CustomError.failedDecode)
            }
        }
        
        dataTask.resume()
    }
}

@available(iOS 15.0.0, *)
extension NetworkInteractor {
    static func fetchPODDataWithAsyncURLSession() async throws -> Apod {
        let urlString = "https://api.nasa.gov/planetary/Apod?api_key="+apiKey
        do {
            let data = try await asyncLoad(url: urlString)
            let picture = try JSONDecoder().decode(Apod.self, from: data)
            return picture
        } catch {
            throw error
        }
    }
        
    static func fetchAsyncImage(_ imageUrl: URL) async throws -> Image {
        do {
            let (fileUrl, _) = try await URLSession.shared.download(from: imageUrl, delegate: nil)
            let data = try Data(contentsOf: fileUrl)
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                return image
            } else {
                throw CustomError.failedImageDecode
            }
        } catch {
            throw error
        }
        
    }
        
    static func fetchPODDataWithContinuation() async throws -> Apod {
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
        
    private static func asyncLoad(url path: String) async throws -> Data {
        guard let url = URL(string: path) else {
            throw CustomError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
        return data
    }
}


