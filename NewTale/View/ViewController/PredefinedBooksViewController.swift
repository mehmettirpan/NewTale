//
//  PredefinedBooksViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 7.10.2024.
//

import UIKit

class PredefinedBooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var stories: [PredefinedStory] = []
    let viewModel = StoryViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Predefined Stories"
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        setupConstraints()

        showLanguageSelectionPopUp()
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Show Language Selection Popup
    func showLanguageSelectionPopUp() {
        let alertController = UIAlertController(title: "Select Language", message: "Which language would you like to read books in?", preferredStyle: .alert)
        
        let languages = ["Turkish", "English", "German", "French", "Russian"]
        for language in languages {
            alertController.addAction(UIAlertAction(title: language, style: .default, handler: { [weak self] _ in
                // Tell the ViewModel to load the JSON for the selected language
                self?.loadJSONForLanguage(language: language)
            }))
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadJSONForLanguage(language: String) {
        let fileName: String
        switch language {
        case "Turkish":
            fileName = "predefinedStories_tr"
        case "English":
            fileName = "predefinedStories_en"
        case "German":
            fileName = "predefinedStories_de"
        case "French":
            fileName = "predefinedStories_fr"
        case "Russian":
            fileName = "predefinedStories_ru"
        default:
            fileName = "predefinedStories_en" // Default to English
        }

        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                
                // Debug: Print the contents of the JSON file
                let jsonString = String(data: data, encoding: .utf8)
//                print("JSON File Contents: \(String(describing: jsonString))")
                
                let decodedResponse = try JSONDecoder().decode(PredefinedStoryResponse.self, from: data)
                
                // Debug: Print the decoded stories
//                print("Decoded Stories: \(decodedResponse.stories)")
                
                stories = decodedResponse.stories
                tableView.reloadData()  // Reload tableView after parsing JSON
            } catch {
                print("Failed to load or decode JSON file: \(error)")
            }
        } else {
            print("JSON file not found: \(fileName).json")
        }
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = stories[indexPath.row].title
        cell.detailTextLabel?.text = stories[indexPath.row].moral ?? "" // Optional if the moral exists
        cell.selectionStyle = .none
        return cell
    }
    
// Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStory = stories[indexPath.row]

        // Initialize StoryViewController
        let storyViewController = StoryViewController()

        // Pass the selected story content
        storyViewController.storyContent = selectedStory.story.joined(separator: "\n")  // Combine story array into a single string
        storyViewController.predefinedStory = selectedStory // Predefined story'yi geçir
        
        // Disable save button for predefined stories
        storyViewController.isFromSavedBooks = true
        
        // Navigate to the StoryViewController
        navigationController?.pushViewController(storyViewController, animated: true)
    }
}


