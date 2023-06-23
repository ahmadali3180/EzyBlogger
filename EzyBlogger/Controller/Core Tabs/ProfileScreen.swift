//
//  ProfileScreen.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 20/06/2023.
//

import UIKit

class ProfileScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    Profile Picture
    
    //    Full Name
    
    //    Email
    
    //    List of Blog Posts
    
    //MARK: - Defining UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    //MARK: - Defining variables
    let currentEmail: String
    private var user: User?
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOut()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: - SignOut Functionality
    
    private func setUpSignOut() {
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
    
    //MARK: - Table View
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchProfileData()
    }
    
    private func setUpTableHeader(profilePicRef: String? = nil, name: String? = nil) {
        let width = view.bounds.width
        let headerView = UIView(frame: CGRect(
            x: 0, y: 0,
            width: width, height: width/1.5 )
        )
        headerView.backgroundColor = .systemGray
        tableView.tableHeaderView = headerView
        headerView.clipsToBounds = true
        
        //        Profile Picture
        let profilePic = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePic.tintColor = .white
        profilePic.contentMode = .scaleAspectFit
        profilePic.frame = CGRect(
            x: (width-(width/4))/2,
            y: (headerView.bounds.height-(width/4))/2.5,
            width: width/4, height: width/4
        )
        headerView.addSubview(profilePic)
        
        //        Email
        let emailLabel = UILabel(frame: CGRect(
            x: 20, y: profilePic.bounds.maxY+52,
            width: width-40, height: 100)
        )
        
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textColor = .white
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        //        Name
        if let name = name {
            title = name
        }
        if let ref = profilePicRef {
            //            Fetch Image
            
        }
    }
    
    //    Fetching Profile Data
    private func fetchProfileData() {
        DBManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {return}
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePicRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var contentConfig = UIListContentConfiguration.cell()
        contentConfig.text = "Title of Cell"
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
