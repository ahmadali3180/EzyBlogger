//
//  ProfileScreen.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 20/06/2023.
//

import UIKit
import Photos
import PhotosUI

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
    private var posts: [BlogPost] = []
    private func fetchPosts() {
        
    }
    
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
        headerView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        headerView.clipsToBounds = true
        
        //        Profile Picture
        let profilePic = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePic.tintColor = .white
        profilePic.contentMode = .scaleAspectFit
        profilePic.frame = CGRect(
            x: (width-(width/4))/2,
            y: (headerView.bounds.height-(width/3))/6,
            width: width/3.5, height: width/3.5
        )
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.isUserInteractionEnabled = true
        headerView.addSubview(profilePic)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        profilePic.addGestureRecognizer(tap)
        
        //        Email
        let emailLabel = UILabel(frame: CGRect(
            x: 20, y: profilePic.bounds.maxY+30,
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
        if let path = profilePicRef {
            //            Fetch Image
            StorageManager.shared.downloadURLForProfilePicture(path: path) { url in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        profilePic.image = UIImage(data: data)
                        headerView.backgroundColor = .clear
                    }
                      
                }
                task.resume()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var contentConfig = UIListContentConfiguration.cell()
        contentConfig.text = "Title of Cell"
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostScreen()
        vc.title =  posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //MARK: - Setting Up Profile
    private func fetchProfileData() {
        DBManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {return}
            guard let strongSelf = self else { return }
            strongSelf.user = user
            DispatchQueue.main.async {
                strongSelf.setUpTableHeader(
                    profilePicRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
    
    @objc private func didTapProfilePic() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else { return }
        openPHPicker()
    }
    
}

extension ProfileScreen: PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                    
                }
                DispatchQueue.main.async {
                    StorageManager.shared.uploadProfilePicture(
                        email: self.currentEmail,
                        image: image) { [weak self] success in
                            guard let strongSelf = self else { return }
                            if success {
                                DBManager.shared.updateProfilePic(email: strongSelf.currentEmail) { updated in
                                    guard updated else {
                                        return
                                    }
                                    strongSelf.fetchProfileData()
                                }
                            }
                        }
                }
            }
        }
        
    }
    
    func openPHPicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images])
        let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
        phPickerVC.delegate = self
        present(phPickerVC, animated: true)
    }
    
}
