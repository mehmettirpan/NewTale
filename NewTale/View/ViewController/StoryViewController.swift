//
//  StoryViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import UIKit
import AVFoundation

class StoryViewController: UIViewController {
    
    let storyTextView = UITextView()
    var storyContent: String?
    var isFromSavedBooks: Bool = false // Flag
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Seslendirme butonları
    let speakButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "speaker.wave.2.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false  // Başlangıçta pasif olacak
        return button
    }()
    
    let resumeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false  // Başlangıçta pasif olacak
        return button
    }()
    
    // Kaydet butonu
    let saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(saveStory))
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Büyük başlık ayarları
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        // Büyük başlık fontunu özelleştir
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 24), // İstediğin font ve boyutu ayarla
            .foregroundColor: UIColor.systemRed // Başlık rengi
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // Save butonu için target ve action ekle
        saveButton.target = self
        saveButton.action = #selector(saveStory)
        
        // Butonlar için hedefler (action) ekle
        speakButton.addTarget(self, action: #selector(speakStory), for: .touchUpInside)
        pauseButton.addTarget(self, action: #selector(pauseStory), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resumeStory), for: .touchUpInside)
        
        // Parse the story to find and set the title
        if let story = storyContent {
            let (formattedText, title) = formatStoryContent(story)
            storyTextView.attributedText = formattedText
            // Büyük başlık ayarları
            navigationItem.title = title  // Set the extracted title to the navigation bar
        }
    }

    func formatStoryContent(_ story: String) -> (NSAttributedString, String?) {
        // Split the story into lines
        let lines = story.split(separator: "\n")
        var title: String?
        var fullText = ""
        
        for line in lines {
            if line.hasPrefix("##") {
                title = line.replacingOccurrences(of: "##", with: "").trimmingCharacters(in: .whitespaces)
                fullText += "\(title!)\n" // Keep title in the full text
            } else {
                fullText += "\(line)\n"
            }
        }
        
        // Create attributed text
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // Apply title formatting (larger font, bold) to the title section
        if let title = title, let titleRange = fullText.range(of: title) {
            let nsRange = NSRange(titleRange, in: fullText)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 24), range: nsRange)
        }
        
        // Apply general text formatting (smaller font size)
        let fullRange = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: fullRange)
        
        // Return the formatted text and the title
        return (attributedText, title)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        // Eğer bu ekrana kaydedilmiş hikayelerden gelinmişse, kaydet butonu gösterilmemeli
        if !isFromSavedBooks {
            navigationItem.rightBarButtonItem = saveButton
        }
        
        storyTextView.isEditable = false
        storyTextView.text = storyContent
        view.addSubview(storyTextView)
        
        // StackView oluşturup butonları ekle
        let buttonStackView = UIStackView(arrangedSubviews: [speakButton, pauseButton, resumeButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 30
        buttonStackView.alignment = .center
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStackView)
        
        setupConstraints(buttonStackView: buttonStackView)
    }

    func setupConstraints(buttonStackView: UIStackView) {
        storyTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            storyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            storyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            storyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            storyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100), // Butonlar için boşluk
            
            // StackView butonlarının konumlandırılması
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            buttonStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // Hikayeyi seslendiren fonksiyon
    @objc func speakStory() {
        guard let story = storyContent else { return }
        
        let utterance = AVSpeechUtterance(string: story)
        utterance.voice = AVSpeechSynthesisVoice(language: "tr-TR")
        utterance.rate = 0.4
        
        speechSynthesizer.speak(utterance)
        
        pauseButton.isEnabled = true
        resumeButton.isEnabled = false
        speakButton.isEnabled = false
    }
    
    @objc func pauseStory() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
            pauseButton.isEnabled = false
            resumeButton.isEnabled = true
        }
    }
    
    @objc func resumeStory() {
        if speechSynthesizer.isPaused {
            speechSynthesizer.continueSpeaking()
            pauseButton.isEnabled = true
            resumeButton.isEnabled = false
        }
    }
    
    @objc func saveStory() {
        guard let story = storyContent else { return }
        
        // Başlık ve formatlanmış hikaye içeriğini elde et
        let (formattedText, title) = formatStoryContent(story)
        
        guard let storyTitle = title else {
            showAlert(message: "Başlık bulunamadı, hikaye kaydedilemiyor.")
            return
        }

        let context = CoreDataStack.shared.context
        let newStory = Story(context: context)
        newStory.title = storyTitle  // Başlık olarak kaydedin
        newStory.content = story
        newStory.createdAt = Date()
        
        do {
            try context.save()
            showAlert(message: "Hikaye başarıyla kaydedildi.")
        } catch {
            print("Hikaye kaydedilemedi: \(error)")
            showAlert(message: "Hikaye kaydedilemedi.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
