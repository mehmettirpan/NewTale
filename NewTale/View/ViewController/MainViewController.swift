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
        storyViewModel.loadJSONForLanguage(language: "English") // Default to English for this example
        
    }
    
    // MARK: - Navigation Bar Setup
    func setupNavigationBar() {
        navigationItem.title = "NEW TALE"
        let leftBarButton = UIBarButtonItem(title: "Ayarlar", style: .plain, target: self, action: #selector(settingsTapped))
        let rightBarButton = UIBarButtonItem(title: "Hikaye Oluştur", style: .plain, target: self, action: #selector(createStoryTapped))
        
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
            cell.configure(with: "Kendi Hikayelerim", items: myStoriesTitles.compactMap { $0 }, at: indexPath)
            print("Fetched stories: \(myStoriesTitles)")
            
            // Tümünü Göster butonuna basıldığında readMyBooks çağır
            cell.showAllButtonAction = { [weak self] _ in
                self?.readMyBooks()
            }
            
        } else {
            // "Hazır Kitaplar" section
            let predefinedTitles = storyViewModel.predefinedStories.map { $0.title }
            cell.configure(with: "Hazır Kitaplar", items: predefinedTitles, at: indexPath)
            
            // Tümünü Göster butonuna basıldığında readPredefinedBooks çağır
            cell.showAllButtonAction = { [weak self] _ in
                self?.readPredefinedBooks()
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Button Actions
    @objc func settingsTapped() {
        // Open Settings page
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
}
