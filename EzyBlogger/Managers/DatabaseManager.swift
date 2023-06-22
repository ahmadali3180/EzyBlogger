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
    
    public func insert(
        user: User,
        completion: @escaping (Bool) -> Void ){
            
        }
    
    
}
