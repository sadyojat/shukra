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
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Show Favorites")
                }
                
                ForEach(filteredItems) { item in
                    NavigationLink {
                        if item.id == "APOD" {
                            APODDetail()
                        } else {
                            Text("\(item.id)")
                        }
                        
                    } label: {
                        MenuRow(item: item)
                    }
                }
            }
            .navigationTitle("NASA Open API's")
        }
        
    }
}

struct MenuList_Previews: PreviewProvider {
    static var previews: some View {
        MenuList().environmentObject(MenuModel())
    }
}
