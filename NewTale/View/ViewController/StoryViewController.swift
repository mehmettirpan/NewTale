//
//  StoryViewController.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import UIKit

class StoryViewController: UIViewController {

    let storyTextView = UITextView()
    var storyContent: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .white
        storyTextView.isEditable = false
        storyTextView.font = UIFont.systemFont(ofSize: 18)
        storyTextView.text = storyContent
        view.addSubview(storyTextView)

        setupConstraints()
    }

    func setupConstraints() {
        storyTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            storyTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            storyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            storyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            storyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}
