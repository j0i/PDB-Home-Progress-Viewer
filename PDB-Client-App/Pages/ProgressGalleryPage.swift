//
//  ProgressGalleryPage.swift
//  PDB-Client-App
//
//  Created by Ben Cramer on 10/25/20.
//

import SwiftUI

struct ProgressGalleryPage: View {
    @Binding var project: Project
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(project.rooms!) { room in
                    Text(room.name)
                        .padding()
                        .font(.system(size: 23))
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(room.images!) { image in
                              
                                NavigationLink(destination: Text("Image Goes Here")) {
                                    ImagePreviewView(image: image)
                                        .frame(width: 150)
                                        .padding([.leading,.trailing], 2.0)
                                }                                
                            }
                        }
                    }
                }
                Spacer()
            }
        }.background(Color("backgroundColor"))
    }
}

/*struct ProgressGalleryPage_Previews: PreviewProvider {
    static var previews: some View {
        ProgressGalleryPage(rooms: [Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Foyer", projectId: "ads"),
            Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)),
                          ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Dining Room", projectId: "ads")
        ])
    }
}*/
