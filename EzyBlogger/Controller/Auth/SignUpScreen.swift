//
//  RegisterScreen.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 21/06/2023.
//

import UIKit

class SignUpScreen: UIViewController {
    
    //    Header View
    private let headerView = SignInHeaderView()
    
    //    Username Field
    private let nameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Full Name"
        textField.autocapitalizationType = .words
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        return textField
    }()
    
    //    Email Field
    private let emailFeild: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        return textField
    }()
    
    //    Password Field
    private let passwordFeild: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    //     Create Account Button
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    //    Create Account Button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailFeild)
        view.addSubview(passwordFeild)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        view.addSubview(createAccountButton)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width: CGFloat = (view.window?.windowScene?.screen.bounds.width)!
        let height: CGFloat = (view.window?.windowScene?.screen.bounds.height)!
        
        headerView.frame = CGRect(
            x: 0, y: view.safeAreaInsets.top,
            width: width, height: height/5)
        nameField.frame = CGRect(
            x: 20, y: headerView.frame.maxY+10,
            width: width-40, height: 50)
        emailFeild.frame = CGRect(
            x: 20, y: nameField.frame.maxY+10,
            width: width-40, height: 50)
        passwordFeild.frame = CGRect(
            x: 20, y: emailFeild.frame.maxY+10,
            width: width-40, height: 50)
        createAccountButton.frame = CGRect(
            x: 20,
            y: passwordFeild.frame.maxY+40,
            width: width-40, height: 50)
        
        
    }
    
    @objc func didTapCreateAccount(){
        guard let email = emailFeild.text, !email.isEmpty,
              let password = passwordFeild.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
            return
        }
        //        Create User
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
            if success {
                //        Update Database
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DBManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {return}
                    
                    UserDefaults.standard.setValue(email, forKey: "email")
                    UserDefaults.standard.setValue(name, forKey: "name")
                     
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("Failed to create an account.")
            }
        }
        
    }
    
    @objc func test() {
        print("!")
    }
    
}
