//
//  DatabaseManager.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 21/06/2023.
//

import Foundation
import FirebaseFirestore

final class DBManager {
    
    static let shared = DBManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insert(
        blogPost: BlogPost,
        for user: User,
        completion: @escaping (Bool) -> Void) {
            
        }
    public func getAllPosts(completion: @escaping ([BlogPost]) -> Void) {
        
    }
    
    public func getPosts(
        for user: User,
        completion: @escaping ([BlogPost]) -> Void) {
            
        }
    
    public func insert(user: User,completion: @escaping (Bool) -> Void ){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name,
            
        ]
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
        
    }
    
    public func getUser(email: String, completion: @escaping (User?) -> Void) {
        
        let documentId = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        database
            .collection("users")
            .document(documentId)
            .getDocument { snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                      error == nil else {
                    return
                }
                let ref = data["profile_picture"]
                let user = User(
                    name: name,
                    email: email,
                    profilePictureRef: ref
                )
                completion(user)
            }
        
    }
    
    public func updateProfilePic(email: String, completion: @escaping (Bool) -> Void) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        let photoRef = "profile_pictures/\(path)/photo.png"
        
        let dbRef = database
            .collection("users")
            .document(path)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else { return }
            
            data["profile_picture"] = photoRef
            
            dbRef.setData(data) { errpor in
                completion(error == nil) // if true -> true, if false -> false
            }
        }
    }
}
