//
//  Launch.swift
//  Shukra
//
//  Created by Sadyojat on 10/17/21.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var launchData: [LaunchElement] = load("launch.json")
}

func load<T: Decodable>(_ fileName: String) -> T {
    var data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldnt find launch file in bundle")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(fileName) from main bundle")
    }
    
    do {
        let launch = try JSONDecoder().decode(T.self, from: data)
        return launch
    } catch {
        fatalError("Failed json decoding \(error.localizedDescription)")
    }
}
