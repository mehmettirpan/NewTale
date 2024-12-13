//
//  LoginViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 6.12.2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var titleText: UILabel = {
        let label = createLabel(text: "NEW TALE", font: .italicSystemFont(ofSize: 60))
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = createTextField(placeholder: "Enter Email")
        textField.autocapitalizationType = .none
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = createTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private let loginButton: UIButton = {
        return createButton(
            title: "Login",
            target: nil,
            action: #selector(loginTapped),
            backgroundColor: .systemBlue,
            cornerRadius: 12,
            textColor: .white
        )
    }()
    private let goToSignUpButton: UIButton = {
        return createButton(
            title: "Go to Sign Up",
            target: nil,
            action: #selector(goToSignUp),
            backgroundColor: .systemBlue,
            cornerRadius: 12,
            textColor: .white
        )
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        [titleText, emailTextField, passwordTextField, loginButton, goToSignUpButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 40),

            goToSignUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToSignUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            goToSignUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            goToSignUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error: \(error)")
                showAlert(on: self, title: "Error", message: error.localizedDescription)
                return
            }
            
            print("Successfully logged in!")
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }

    @objc private func goToSignUp() {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}
