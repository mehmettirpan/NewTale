//
//  MyBooksViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 7.10.2024.
//

import UIKit
import CoreData

class MyBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    var stories: [Story] = []
    let viewModel: StoryViewModel
    
    // Initializer: ViewModel dışarıdan veriliyor
    init(viewModel: StoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("STORIES_CREATED", comment: "STORIES_CREATED")

        view.addSubview(tableView)
        setupConstraints()

        // ViewModel'den gelen hikayeler güncellendiğinde tabloyu yeniden yükle
        viewModel.onStoriesUpdated = { [weak self] in
            self?.stories = self?.viewModel.myStories ?? []
            self?.tableView.reloadData()
        }
        
        viewModel.fetchMyStories() // Hikayeleri yükle
        
        tableView.delegate = self
        tableView.dataSource = self
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



    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let story = stories[indexPath.row].content ?? ""
        
        // Başlık ve Konu ayıklama
        if let title = extractTitle(from: story) {
            cell.textLabel?.text = title
        } else {
            cell.textLabel?.text = NSLocalizedString("Title is not found", comment: "Title is not found")
        }
        
        if let topic = extractTopic(from: story) {
            cell.detailTextLabel?.text = topic
        } else {
            cell.detailTextLabel?.text = NSLocalizedString("Topic is not found", comment: "Topic is not found")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStory = stories[indexPath.row]
        let storyVC = StoryViewController()
        
        storyVC.storyContent = selectedStory.content
        storyVC.isFromSavedBooks = true // Burada flag'ı ayarlıyoruz
        
        navigationController?.pushViewController(storyVC, animated: true)
    }
    
    // Başlığı "##" sembolüyle başlayan satırdan ayıkla
    func extractTitle(from story: String) -> String? {
        let lines = story.split(separator: "\n")
        
        // İlk "##" ile başlayan satırı bul ve "##" işaretlerini kaldır
        for line in lines {
            if line.hasPrefix("##") {
                return line.replacingOccurrences(of: "##", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        
        return nil // Eğer "##" ile başlayan satır yoksa, nil döndür
    }
    
    // "Konu: ..." ile başlayan satırı ayıkla
    func extractTopic(from story: String) -> String? {
        let lines = story.split(separator: "\n")
        
        // İlk "Konu: " ile başlayan satırı bul ve "Konu: " kısmını kaldır
        for line in lines {
            if line.hasPrefix("Konu:") {
                return line.replacingOccurrences(of: "Konu:", with: "").trimmingCharacters(in: .whitespaces)
            }
        }
        
        return nil // Eğer "Konu: " ile başlayan satır yoksa, nil döndür
    }
}
