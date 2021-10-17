//
//  CircleImage.swift
//  Shukra
//
//  Created by Sadyojat on 10/14/21.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    
    var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 7)            
            .aspectRatio(contentMode: .fit)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("Apod"))
    }
}
