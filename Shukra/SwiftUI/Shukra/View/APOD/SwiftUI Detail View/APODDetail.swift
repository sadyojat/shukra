//
//  APODDetail.swift
//  Shukra
//
//  Created by Sadyojat on 10/18/21.
//

import SwiftUI

struct APODDetail: View {
    
    @State private var apodObject: Apod?
    @State private var apodImage: Image?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: nil) {
                
                if let image = apodImage {
                    image
                        .resizable()
                        .aspectRatio(4/3, contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                }
                
                HStack(alignment: .center, spacing: 10, content: {
                    VStack(alignment: .leading) {
                        Text("\(apodObject?.title ?? "")")
                            .font(.headline)
                            .bold()
                        .foregroundColor(.accentColor)
                    }
                    Divider()
                    VStack(alignment: .trailing) {
                        Text("\(apodObject?.date ?? "")")
                            .font(Font.subheadline)
                            .bold()
                        .foregroundColor(Color.accentColor)
                    }

                })
                Spacer()
                Divider()
                Spacer()
                Text("\(apodObject?.explanation ?? "")")
                Spacer()
            }
            .padding()
            .onAppear {
                Task {
                    do {
                        self.apodObject = try await ApodService().load()
                        if let aObject = apodObject,
                            let imageurl = aObject.hdurl,
                            let url = URL(string: imageurl) {
                            self.apodImage = try await ApodService().loadImage(url)                                                                                                                                                                                              
                        }
                    } catch {
                        print("Error:: async failed")
                    }
                }
            }
        }
        .navigationTitle("Astronomy Picture of the day")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct APODDetail_Previews: PreviewProvider {
    static var previews: some View {
        APODDetail()
    }
}
