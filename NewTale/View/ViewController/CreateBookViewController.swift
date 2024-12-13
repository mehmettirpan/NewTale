//
//  CreateBookViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 7.10.2024.
//

import UIKit

class CreateBookViewController: UIViewController {
    //    MARK: - UI elements

    let storyViewModel = StoryViewModel()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let ageLabel = createLabel(
        text: NSLocalizedString("AGE_LABEL", comment: "Age Label"),
        font: UIFont.boldSystemFont(ofSize: 16)
    )
    
    let ageTextField = createTextField(
        placeholder: NSLocalizedString(
            "AGE_PLACEHOLDER",
            comment: "Age placeholder"
        )
    )
    
    let interestLabel = createLabel(
        text: NSLocalizedString(
            "INTEREST_LABEL",
            comment: "Interest Label"
        ),
        font: UIFont.boldSystemFont(ofSize: 16)
    )
    
    let interestTextField = createTextField(
        placeholder: NSLocalizedString(
            "INTEREST_PLACEHOLDER",
            comment: "Interest placeholder"
        )
    )
    
    let purposeLabel = createLabel(
        text: NSLocalizedString(
            "PURPOSE_LABEL",
            comment: "Purpose Label"
        ),
        font: UIFont.boldSystemFont(ofSize: 16)
    )
    
    let purposeTextField = createTextField(
        placeholder: NSLocalizedString("PURPOSE_PLACEHOLDER",comment: "Message placeholder")
    )
    
    let generateStoryButton = createButton(
        title: NSLocalizedString("SUBMIT", comment: "Submit"),
        target: self,
        action: #selector(generateStoryButtonTapped),
        backgroundColor: .systemBlue,
        cornerRadius: 12,
        textColor: .systemBackground
    )
    
    lazy var stackView: UIStackView = {
        let stack = createStackView(
            arrangedSubviews: [
                ageLabel,
                ageTextField,
                interestLabel,
                interestTextField,
                purposeLabel,
                purposeTextField,
                enableDetailsLabel,
                detailsSwitch,
                generateStoryButton
            ],
            axis: .vertical,
            spacing: 18
        )
        
        // Customize spacing between specific elements
        stack.setCustomSpacing(8, after: ageLabel)
        stack.setCustomSpacing(8, after: interestLabel)
        stack.setCustomSpacing(8, after: purposeLabel)
        stack.setCustomSpacing(16, after: detailsSwitch)
        stack.setCustomSpacing(24, after: purposeTextField)
        
        // Button height
        generateStoryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return stack
    }()

    // Switch label
    lazy var enableDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Enable additional story details", comment: "Enable additional story details")
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Switch for enabling additional fields
    lazy var detailsSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.addTarget(self, action: #selector(detailsSwitchToggled), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    // Fields to be dynamically added
    lazy var mainCharacterLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Main Character Label", comment: "Main Character Label")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    lazy var mainCharacterTextField: UITextField = {
        createTextField(placeholder: NSLocalizedString("Enter main character", comment: "Enter main character"))
    }()

    lazy var storyLocationLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Story Location Label", comment: "Story Location Label")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    lazy var storyLocationTextField: UITextField = {
        createTextField(placeholder: NSLocalizedString("Enter story location", comment: "Enter story location"))
    }()

    
    var storyContent: String?
    
    //    MARK: - View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupKeyboardObservers() // Klavye olaylarını dinle
        // Gesture Recognizer ekle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        // Bildirim gözlemcilerini kaldır
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupScrollView() {
        // ScrollView ve ContentView'i ana görünüme ekle
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        // Auto Layout'u etkinleştir
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // ScrollView ana görünüme sabitleniyor
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            // ContentView, ScrollView'in içeriğine sabitleniyor
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), // Genişlik eşleşmesi gerekiyor

            // StackView, ContentView'in içine yerleştiriliyor
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    //    MARK: - Functions

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
//    MARK: - Objc Functions
    @objc func detailsSwitchToggled() {
        if detailsSwitch.isOn {
            // Add mainCharacter and storyLocation fields
            stackView.addArrangedSubview(mainCharacterLabel)
            stackView.addArrangedSubview(mainCharacterTextField)
            stackView.addArrangedSubview(storyLocationLabel)
            stackView.addArrangedSubview(storyLocationTextField)
        } else {
            // Remove them if switch is off
            mainCharacterLabel.removeFromSuperview()
            mainCharacterTextField.removeFromSuperview()
            storyLocationLabel.removeFromSuperview()
            storyLocationTextField.removeFromSuperview()
        }
        
        // Ensure the generateStoryButton stays at the bottom
        stackView.removeArrangedSubview(generateStoryButton)
        stackView.addArrangedSubview(generateStoryButton)
    }
    
    @objc func generateStoryButtonTapped() {
        guard let ageText = ageTextField.text, let age = Int(ageText),
              let interest = interestTextField.text, !interest.isEmpty,
              let purpose = purposeTextField.text, !purpose.isEmpty else {
            showAlert(on: self, title: "Error", message: "Please fill in all fields.")
            return
        }

        // Opsiyonel alanları kontrol et
        let mainCharacter = mainCharacterTextField.text?.isEmpty == false ? mainCharacterTextField.text : nil
        let storyLocation = storyLocationTextField.text?.isEmpty == false ? storyLocationTextField.text : nil

        // StoryInput nesnesini oluştur
        let storyInput = StoryInput(
            age: age,
            interest: interest,
            purpose: purpose,
            language: storyViewModel.getDeviceLanguage(),
            mainCharacter: mainCharacter,
            storyLocation: storyLocation
        )

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
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)  // Klavyeyi kapat
    }
}
