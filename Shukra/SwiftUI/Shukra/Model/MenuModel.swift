//
//  MenuModel.swift
//  Shukra
//
//  Created by Sadyojat on 10/17/21.
//

import Foundation

final class MenuModel: ObservableObject {
    @Published var launchData: [MenuItem] = load("mainmenu.json")
    @Published var mainMenu: [MenuItem] = load("mainmenu.json")
}

public func load<T: Decodable>(_ fileName: String) -> T {
    var data: Data
    
    guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Couldnt find launch file \(fileName) in bundle")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(fileName) from main bundle")
    }
    
    do {
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        return decodedObject
    } catch {
        fatalError("Failed json decoding \(error.localizedDescription)")
    }
}
