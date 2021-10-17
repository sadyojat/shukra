//
//  LaunchList.swift
//  Shukra
//
//  Created by Sadyojat on 10/17/21.
//

import SwiftUI

struct LaunchList: View {
    
    @State private var showFavoritesOnly = false
    
    @EnvironmentObject var modelData: ModelData
    
    var filteredElements: [LaunchElement] {
        modelData.launchData.filter { $0.isFavorite || !showFavoritesOnly }
    }
    
    var body: some View {
        Text("TODO :: Build API List")
        
    }
}

struct LaunchList_Previews: PreviewProvider {
    static var previews: some View {
        LaunchList()
    }
}
