//
//  MenuList.swift
//  Shukra
//
//  Created by Sadyojat on 10/17/21.
//

import SwiftUI

struct MenuList: View {
    
    @State private var showFavoritesOnly = false
    
    @EnvironmentObject var menumodel: MenuModel
    
    var filteredItems: [MenuItem] {
        menumodel.launchData.filter { $0.isFavorite ?? false || !showFavoritesOnly }
    }
    
    @Binding var searchText: String
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Show Favorites")
                }
                
                ForEach(filteredItems) { item in
                    NavigationLink {
                        switch item.id {
                        case "APOD":
                            APODDetail()
                        case "Mars Rover Photos":
                            MarsRover()                            
                        default:
                            Text("\(item.id)")
                        }
                    } label: {
                        MenuRow(item: item)
                    }
                }
            }
            .navigationTitle("NASA Open API's")
        }
        .searchable(text: $searchText)
    }
}

struct MenuList_Previews: PreviewProvider {
    @State static var testString = "Test"
    static var previews: some View {
        MenuList(searchText: $testString).environmentObject(MenuModel())
    }
}
