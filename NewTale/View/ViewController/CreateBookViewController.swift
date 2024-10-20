//
//  CreateBookViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 7.10.2024.
//

import UIKit

class CreateBookViewController: UIViewController {

    let storyViewModel = StoryViewModel()
    
    let ageTextField = createTextField(placeholder: NSLocalizedString("AGE_PLACEHOLDER", comment: "Age placeholder"))
    let interestTextField = createTextField(placeholder: NSLocalizedString("INTEREST_PLACEHOLDER", comment: "Interest placeholder"))
    let purposeTextField = createTextField(placeholder: NSLocalizedString("GENERATE_PLACEHOLDER", comment: "Generate placeholder"))
    let generateStoryButton = createButton(title: NSLocalizedString("SUBMIT", comment: "Submit"), target: self, action: #selector(generateStoryButtonTapped))
    
    var storyContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(ageTextField)
        view.addSubview(interestTextField)
        view.addSubview(purposeTextField)
        view.addSubview(generateStoryButton)
        
        setupConstraints()
    }

    func setupConstraints() {
        ageTextField.translatesAutoresizingMaskIntoConstraints = false
        interestTextField.translatesAutoresizingMaskIntoConstraints = false
        purposeTextField.translatesAutoresizingMaskIntoConstraints = false
        generateStoryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ageTextField.heightAnchor.constraint(equalToConstant: 40),

            interestTextField.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 20),
            interestTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            interestTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            interestTextField.heightAnchor.constraint(equalToConstant: 40),

            purposeTextField.topAnchor.constraint(equalTo: interestTextField.bottomAnchor, constant: 20),
            purposeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            purposeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            purposeTextField.heightAnchor.constraint(equalToConstant: 40),

            generateStoryButton.topAnchor.constraint(equalTo: purposeTextField.bottomAnchor, constant: 30),
            generateStoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generateStoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generateStoryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func generateStoryButtonTapped() {
        guard let ageText = ageTextField.text, let age = Int(ageText),
              let interest = interestTextField.text, !interest.isEmpty,
              let purpose = purposeTextField.text, !purpose.isEmpty else {
            showAlert(message: NSLocalizedString("Please fill in all fields.", comment: "Please fill in all fields."))
            return
        }

        let storyInput = StoryInput(age: age, interest: interest, purpose: purpose, language: storyViewModel.getDeviceLanguage())

        // API çağrısını başlat
        storyViewModel.generateStory(input: storyInput) { [weak self] storyContent in
            DispatchQueue.main.async {
                self?.storyContent = storyContent
                let storyVC = StoryViewController()
                storyVC.storyContent = storyContent
                self?.navigationController?.pushViewController(storyVC, animated: true)
            }
        }
    }

    // Yardımcı fonksiyon: Uyarı göstermek için
    func showAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("ERROR", comment: "Error"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
