//
//  SignInScreen.swift
//  EzyBlogger
//
//  Created by M. Ahmad Ali on 21/06/2023.
//

import UIKit
import FirebaseAuth

class SignInScreen: UIViewController {
    
    //    Header View
    private let headerView = SignInHeaderView()
    
    //    Email Field
    private let emailFeild: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 8
        textField.autocorrectionType = .no
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
    
    //     SignIn Button
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.configuration = .filled()
        button.layer.cornerRadius = 12
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    //    Create Account Button
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailFeild)
        view.addSubview(passwordFeild)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width: CGFloat = (view.window?.windowScene?.screen.bounds.width)!
        let height: CGFloat = (view.window?.windowScene?.screen.bounds.height)!
        
        headerView.frame = CGRect(
            x: 0, y: view.safeAreaInsets.top,
            width: width, height: height/5)
        emailFeild.frame = CGRect(
            x: 20, y: headerView.frame.maxY+10,
            width: width-40, height: 50)
        passwordFeild.frame = CGRect(
            x: 20, y: emailFeild.frame.maxY+10,
            width: width-40, height: 50)
        signInButton.frame = CGRect(
            x: 20,
            y: passwordFeild.frame.maxY+40,
            width: width-40, height: 50)
        createAccountButton.frame = CGRect(
            x: 20,
            y: signInButton.frame.maxY+60,
            width: width-40, height: 50)
        
    }
    
    @objc func didTapSignIn() {
        let alert = UIAlertController(title: "Sign In Failed", message: "Please Try Again", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .cancel)
        alert.addAction(action)
        
        guard let email = emailFeild.text, !email.isEmpty,
              let password = passwordFeild.text, !password.isEmpty else {
            return
        }
        //        Authenticate User
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            if success {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            } else {
                self?.present(alert, animated: true)
            }
        }
        //        Login User
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpScreen()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
