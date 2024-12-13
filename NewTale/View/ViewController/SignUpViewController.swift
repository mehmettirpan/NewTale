//
//  SignInViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 6.12.2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
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
    private let signUpButton: UIButton = {
        return createButton(
            title: "Sign Up",
            target: nil,
            action: #selector(signUpTapped),
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
        view.backgroundColor = .white
        [titleText, emailTextField, passwordTextField, signUpButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.15),
            titleText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func signUpTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign Up Error: \(error)")
                showAlert(on: self, title: "Error", message: error.localizedDescription)
                return
            }
            
            print("Successfully signed up!")
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }

}
