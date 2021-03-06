//
//  HomePageVM.swift
//  PDB-Client-App
//
//  Created by Ben Cramer on 10/24/20.
//

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseUI

class HomePageVM: ObservableObject {
    @Published var projects = [Project]()
    
    var db = Firestore.firestore().collection("Projects")
    var userdb = Firestore.firestore().collection("Users")
    func getProjects()
    {
        self.getUser()
            { user in
              self.projects = [Project]()
                for p in user.Projects
                {
                    let projectQuery = self.db.document(p)
                    projectQuery.getDocument{
                        document, error in
                        if let document = document
                        {
                           let name = document.get("name") as? String ?? ""
                           let builderEmail = document.get("builderEmail") as? String ?? ""
                           let imageURL = document.get("imageURL") as? String ?? "https://firebasestorage.googleapis.com/v0/b/pd-builders.appspot.com/o/testProject%2FPDB%20(2).jpg?alt=media&token=b2cacd69-40ca-4ea4-869c-635d1b500743"
                           let address = document.get("address") as? String ?? ""
                           let archived = document.get("archived") as? Bool ?? false
                
                self.getRooms(id: p)
                    { rooms in
                        
                        //var forms = [ChangeOrderForm]()
                       //self.getForms(id: p) { forms in
                            let size = self.projects.count
                            if(size != 0)
                            {
                                if (self.projects[size-1].docId == p)
                                {
                                    self.projects.removeLast()
                                }
                            }
                            
                    self.projects.append((Project(builderEmail: builderEmail, imageURL: imageURL, name: name, address: address, archived: archived, rooms: rooms, docId: p)))
                      //  }
                    }
              }
            }
          }
        }
    }

    func getRooms(id: String, completion: @escaping (([Room]) -> ()))
    {
        var rooms = [Room]()
        self.db.document(id).collection("Rooms").getDocuments
        {
            QuerySnapshot, error in
            for document in QuerySnapshot!.documents
            {
                let name = document.data()["name"] as? String ?? ""
                var images = [ImageModel]()
                self.db.document(id).collection("Rooms").document(document.documentID).collection("Images").getDocuments(completion:
                {
                    QuerySnapshot, error in
                    self.imagesFromSnapshot(querySnap: QuerySnapshot!) { images in
                        rooms.append(Room(id: UUID(), name: name, images: images))
                        completion(rooms)
                    }
                        
                    
                 })
                
                
             }
            if(QuerySnapshot?.documents.count==0)
            {
                completion(rooms)
            }
         }
     }
      
    func imagesFromSnapshot(querySnap: QuerySnapshot, completion:@escaping (([ImageModel]) -> ())) {
        var images = [ImageModel]()
        
        for document in querySnap.documents
        {
            
            let imageRef = document.data()["imageURL"] as? String ?? ""
            let datestring = document.data()["date"] as? String ?? Date(timeIntervalSinceNow: 0).ToString()
            let date = Date.String(from: datestring)
            let is360 = document.data()["is360"] as? Bool ?? false
            images.append(ImageModel(id: UUID(), imageURL: imageRef, date: date, is360: is360))
            
        }
        
        completion(images)
    }
    
    func getUser(completion: @escaping((User)->()))
    {
        var empty = [String]()
            empty.append("")
        var user = User(firstname: "", lastname: "", phoneNumber: "", emailAddress: "", projects: empty) 
            let userEmail = Auth.auth().currentUser?.email
                userdb.whereField("users_email", isEqualTo: userEmail).getDocuments{
                QuerySnapshot, error in
                for document in QuerySnapshot!.documents
                {
                    let first = document.data()["users_firstname"] as? String ?? ""
                    let last = document.data()["users_lastname"] as? String ?? ""
                    let phone = document.data()["users_phone"] as? String ?? ""
                    let email = document.data()["users_email"] as? String ?? ""
                    var userProjects = document.data()["projects"] as? [String]
                    user = User(firstname: first, lastname: last, phoneNumber: phone, emailAddress: email, projects: userProjects ?? empty)
                    completion(user)
                }
        
               
            }
    }
    
    /*func getImages(pid: String, rid: String, completion: @escaping (([ImageModel]) -> ()))
    {
        var images = [ImageModel]()
        self.db.document(pid).collection("Rooms").document(rid).collection("Images").getDocuments(completion:
        {
            QuerySnapshot, error in
     
                for document in QuerySnapshot!.documents
                {
                    let imageRef = document.data()["imageURL"] as? String ?? ""
                    images.append(ImageModel(id: UUID(), imageURL: imageRef, date: Date(timeIntervalSinceNow: 0)))
                    
                }
        })
        completion(images)
    }*/

    
}


    //TODO: Pull these from the logged in user
    /*@Published var projects = [
        Project(imageURL: "", name: "Proj1", address: "addr1", rooms: [Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)),
                                                                                     ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Foyer"),
            Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Dining Room"),
            Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)),
                                                                                         ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Foyer"),
            Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)),
                                                                                         ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Foyer"),
            Room(images: [ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0)),
                                                                                         ImageModel(imageData: "This is an image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is another image", date: Date(timeIntervalSinceNow: 0)), ImageModel(imageData: "This is yet another image", date: Date(timeIntervalSinceNow: 0))], name: "Foyer")], forms: [
                                    ChangeOrderForm(title: "A form", description: "A description")                                                     ]),
        Project(imageURL: "", name: "Proj2", address: "addr2"),
        Project(imageURL: "", name: "Proj3", address: "addr3")
    ]*/


struct HomePageVM_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
