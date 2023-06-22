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
        let alertSheet = UIAlertController(title: "Sign Out", message: "Are you sure you'd like to sign out?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.setValue(nil, forKey: "email")
                        UserDefaults.standard.setValue(nil, forKey: "name")
                        let signInVC = SignInScreen()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC,animated: true)
                    }
                } else {
                    print("not logged out")
                }
            }
        }
        
        alertSheet.addAction(confirmAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true)
        
    }
    
}
