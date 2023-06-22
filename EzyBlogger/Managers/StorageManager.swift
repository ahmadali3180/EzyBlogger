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
    
    private let container = Storage.storage().reference()
    
    private init() {}
    
    public func uploadProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void) {
        
    }
    
    public func downloadURLForProfilePicture(
        user: User,
        completion: @escaping (URL?) -> Void) {
            
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
