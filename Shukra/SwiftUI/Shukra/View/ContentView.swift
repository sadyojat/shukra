//
//  ContentView.swift
//  Shukra
//
//  Created by Sadyojat on 10/12/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        MenuList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MenuModel())
    }
}
