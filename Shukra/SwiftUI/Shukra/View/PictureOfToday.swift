//
//  PictureOfToday.swift
//  Shukra
//
//  Created by Sadyojat on 10/14/21.
//

import SwiftUI

struct PictureOfToday: View {
        
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: nil, content: {
                Image("Apod")
                    .resizable()
                    .aspectRatio(16/9, contentMode: ContentMode.fit)
                    .cornerRadius(20.0)
                    
                
                Text("Explanation")
                    .font(.caption)
            })
                .padding()
        }
        .navigationTitle("Title")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
}

struct PictureOfToday_Previews: PreviewProvider {
    static var previews: some View {
        PictureOfToday()
//.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
