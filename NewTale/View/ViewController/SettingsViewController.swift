//
//  SettingsViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 6.12.2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    lazy var logoutButton: UIButton = {
        return createButton(
            title: "Logout",
            target: nil,
            action: #selector(
                logoutTapped
            ),
            backgroundColor: .systemRed,
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
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            print("Successfully logged out")
            
            // Çıkış sonrası login ekranına yönlendir
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController = navigationController
        } catch {
            print("Failed to log out: \(error.localizedDescription)")
        }
    }
}
