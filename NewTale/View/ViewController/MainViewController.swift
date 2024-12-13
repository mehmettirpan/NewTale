//
//  ViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

/*
 Motto: Kendi masalını özgürce yazmak isteyenler için
 */
import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let storyViewModel = StoryViewModel()
    let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavigationBar()
        // Set up the ViewModel's callback
        storyViewModel.onStoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // Fetch my stories and predefined stories
        storyViewModel.fetchMyStories()
        storyViewModel.loadJSONForLanguage(language: NSLocalizedString("Default Language", comment: "Default Language")) // Default to English for this example
    }
    
    // MARK: - Navigation Bar Setup
    func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("NEW TALE", comment: "NEW TALE")
        let leftBarButton = UIBarButtonItem(title: NSLocalizedString("SETTINGS", comment: "Settings"), style: .plain, target: self, action: #selector(settingsTapped))
        let rightBarButton = UIBarButtonItem(title: NSLocalizedString("CREATE_STORY", comment: "Create Story"), style: .plain, target: self, action: #selector(createStoryTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: - Table View Setup
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(StorySectionCell.self, forCellReuseIdentifier: "StorySectionCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Two sections: My Stories and Predefined Books
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1  // Single row for "Kendi Hikayelerim" which will horizontally scroll
        } else {
            return 1  // Single row for "Hazır Kitaplar" which will horizontally scroll
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorySectionCell", for: indexPath) as! StorySectionCell
        
        if indexPath.section == 0 {
            // "Kendi Hikayelerim" section
            let myStoriesTitles = storyViewModel.myStories.map { $0.title }
            cell.configure(with: NSLocalizedString("STORIES_CREATED", comment: "Stories Created"), items: myStoriesTitles.compactMap { $0 }, at: indexPath)
            print("Fetched stories: \(myStoriesTitles)")
            
            // Tümünü Göster butonuna basıldığında readMyBooks çağır
            cell.showAllButtonAction = { [weak self] _ in
                self?.readMyBooks()
            }
            
            // Seçilen hikayeye göre okuma ekranına yönlendirme
            cell.itemSelectedAction = { [weak self] selectedStoryTitle in
                self?.openStoryReadingScreen(with: selectedStoryTitle, isPredefined: false)
            }
            
        } else {
            // "Hazır Kitaplar" section
            let predefinedTitles = storyViewModel.predefinedStories.map { $0.title }
            cell.configure(with: NSLocalizedString("PREDEFINED_STORIES", comment: "Predefined Stories"), items: predefinedTitles, at: indexPath)
            
            // Tümünü Göster butonuna basıldığında readPredefinedBooks çağır
            cell.showAllButtonAction = { [weak self] _ in
                self?.readPredefinedBooks()
            }
            
            // Seçilen hazır kitabı okuma ekranına yönlendirme
            cell.itemSelectedAction = { [weak self] selectedStoryTitle in
                self?.openStoryReadingScreen(with: selectedStoryTitle, isPredefined: true)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Button Actions
    @objc func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    @objc func createStoryTapped() {
        let createStoryVC = CreateBookViewController()
        navigationController?.pushViewController(createStoryVC, animated: true)
    }

    @objc func readPredefinedBooks() {
        let predefinedBooksVC = PredefinedBooksViewController()
        navigationController?.pushViewController(predefinedBooksVC, animated: true)
    }

    @objc func readMyBooks() {
        let myBooksVC = MyBooksViewController(viewModel: storyViewModel) // Burada viewModel geçiliyor
        navigationController?.pushViewController(myBooksVC, animated: true)
    }
    
//    MARK: - Functions
    func openStoryReadingScreen(with title: String, isPredefined: Bool) {
        if isPredefined {
            // Handle predefined stories
            if let selectedStory = storyViewModel.predefinedStories.first(where: { $0.title == title }) {
                let storyVC = StoryViewController()

                // Combine the `story` array into a single string and pass it
                let storyContent = selectedStory.story.joined(separator: " ")
                storyVC.storyContent = storyContent
                
                // Pass the full PredefinedStory object
                storyVC.predefinedStory = selectedStory // Pass predefined story here
                
                // If there's a moral, append it to the story content
                if let moral = selectedStory.moral {
                    storyVC.storyContent! += "\n\nMoral: \(moral)"
                }

                storyVC.isFromSavedBooks = true // Since it's a predefined story
                navigationController?.pushViewController(storyVC, animated: true)
            } else {
                print("Predefined story not found")
            }
        } else {
            // Handle user-created stories
            if let selectedStory = storyViewModel.myStories.first(where: { $0.title == title }) {
                let storyVC = StoryViewController()
                storyVC.storyContent = selectedStory.content // Pass user-created story content
                storyVC.isFromSavedBooks = true // Since it's a user-created story
                navigationController?.pushViewController(storyVC, animated: true)
            } else {
                print("User story not found")
            }
        }
    }
}
