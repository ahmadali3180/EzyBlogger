//
//  ProfileScreen.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 20/06/2023.
//

import UIKit

class ProfileScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self, action: #selector(didTapSignOut))
    }
    
    @objc private func didTapSignOut() {
        
    }
    
}
