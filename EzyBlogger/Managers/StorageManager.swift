//
//  StorageManager.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 21/06/2023.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    public func uploadProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void) {
            let path = email
                .replacingOccurrences(of: "@", with: "_")
                .replacingOccurrences(of: ".", with: "_")
            guard let pngData = image?.pngData() else {
                return
                
            }
            
            container
                .reference(withPath: "profile_pictures/\(path)/photo.png")
                .putData(pngData, metadata: nil) { metaData, error in
                    guard metaData != nil, error == nil else {
                        completion(false)
                        return
                        
                    }
                    completion(true)
                }
        }
    
    public func downloadURLForProfilePicture(
        path: String,
        completion: @escaping (URL?) -> Void) {
            container.reference(withPath: path)
                .downloadURL { url, _ in
                    completion(url)
                }
        }
    
    public func uploadBlogHeaderImage(
        blogPost: BlogPost,
        image: UIImage?,
        completion: @escaping (Bool) -> Void) {
            
        }
    
    public func downloadURLForPostHeaderImage(
        blogPost: BlogPost,
        completion: @escaping (URL?) -> Void) {
            
        }
    
}
