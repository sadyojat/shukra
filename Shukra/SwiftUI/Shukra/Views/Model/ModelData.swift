//
//  ModelData.swift
//  Shukra
//
//  Created by Alok Irde on 10/12/21.
//

import Foundation
import SwiftUI
import Combine

var apiKey = "QpaRwg94lcrw75Befex6xRahvMdwbypgZa2MtROY"

final class ModelData: ObservableObject {
    @Published var cachedImages = [String: Image]()
    @Published var savedImages = [String: URL]()
}

let supporteImageMimeTypes: [String] = ["image/png", "image/jpg", "image/jpeg"]

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


class Router {
    
    static let shared = Router()
    
    func load(url path: String, completionHandler: ((Data?, String?, Error?)->())?) {
        guard let url = URL(string: path) else {
            completionHandler?(nil, nil, CustomError.invalidURL)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { dataOrNil, responseOrNil, errorOrNil in
            if let _ = errorOrNil {
                completionHandler?(nil, nil, CustomError.failedDownload)
            }
            guard let response = responseOrNil as? HTTPURLResponse,
               (200...299).contains(response.statusCode) else {
                   completionHandler?(nil, nil, CustomError.invalidResponse)
                   return
            }
            
            if let mimeType = response.mimeType,
               let data = dataOrNil {
                completionHandler?(data, mimeType,  nil)
            } else  {
                completionHandler?(nil, nil, CustomError.failedDecode)
            }
        }
        
        dataTask.resume()
    }

    enum DownloadLocation {
        case onDisk
        case inMemory
    }

    private func downloadImage(from path: String, at location: DownloadLocation = .inMemory, completionHandler: ((Image?, Error?)->())?) {
        guard let url = URL(string: path) else {
            return
        }
        
        if location == .onDisk {
            let downloadTask = URLSession.shared.downloadTask(with: url) { urlOrNil, responseOrNil, errorOrNil in
                guard let imageUrl = urlOrNil else { return }
                
                do {
                    let downloadsUrl = try FileManager.default.url(for: .downloadsDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
                    let savedURL = downloadsUrl.appendingPathComponent(imageUrl.lastPathComponent)
                    try FileManager.default.moveItem(at: imageUrl, to: savedURL)
                    let data = try Data(contentsOf: savedURL)
                    ModelData().savedImages[path] = savedURL
                    if let uiImage = UIImage(data: data) {
                        completionHandler?(Image(uiImage: uiImage), nil)
                    }
                } catch {
                    completionHandler?(nil, CustomError.failedDownload)
                }
            }
            downloadTask.resume()
        } else {
            load(url: path) { dataOrNil, mimeOrNil, errorOrNil in
                if let mimeType = mimeOrNil, supporteImageMimeTypes.contains(mimeType),
                   let data = dataOrNil {
                    if let uiImage = UIImage(data: data) {
                        completionHandler?(Image(uiImage: uiImage), nil)
                    } else {
                        completionHandler?(nil, CustomError.failedImageDecode)
                    }
                } else {
                    completionHandler?(nil, CustomError.failedImageDecode)
                }
            }
        }
        
    }

    func retrieveImage(at path: String, completionHandler: ((Image?, Error?)->())?) {
        if let image = ModelData().cachedImages[path] {
            completionHandler?(image, nil)
        } else {
            downloadImage(from: path, at: .inMemory) { imageOrNil, errorOrNil in
                if let error = errorOrNil {
                    completionHandler?(nil, error)
                }
                
                if let image = imageOrNil {
                    completionHandler?(image, nil)
                }
            }
        }
    }

    func flushCaches() {
        
    }
}

