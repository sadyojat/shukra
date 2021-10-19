//
//  MenuRow.swift
//  Shukra
//
//  Created by Sadyojat on 10/18/21.
//

import SwiftUI

struct MenuRow: View {
    
    var item: MenuItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading,  content: {
                Text("\(item.id)")
                    .font(.title2).bold()
                Text("\(item.description)")
                    .font(.caption)
            })
            Spacer()
            if item.isFavorite ?? false {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct MenuRow_Previews: PreviewProvider {
    static var launchData = MenuModel().launchData
    
    static var previews: some View {
        Group {
            MenuRow(item: launchData[0])
            MenuRow(item: launchData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
