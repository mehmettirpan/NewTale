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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        setupConstraints()
        fetchStories()
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

    func fetchStories() {
        let request: NSFetchRequest<Story> = Story.fetchRequest()

        do {
            let fetchedStories = try CoreDataStack.shared.context.fetch(request)
            stories = fetchedStories
            tableView.reloadData()
        } catch {
            print("Hikayeler yüklenemedi: \(error)")
        }
    }

    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = stories[indexPath.row].content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStory = stories[indexPath.row]
        let storyVC = StoryViewController()
        
        storyVC.storyContent = selectedStory.content
        storyVC.isFromSavedBooks = true // Burada flag'ı ayarlıyoruz
        
        navigationController?.pushViewController(storyVC, animated: true)
    }
}
