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

class MainViewController: UIViewController {

    let storyViewModel = StoryViewModel()
    
    let readPredefinedBooksButton = createButton(title: "Hazır Kitapları Oku", target: self, action: #selector(readPredefinedBooks))
    let readMyBooksButton = createButton(title: "Hazırladığım Kitaplardan Oku", target: self, action: #selector(readMyBooks))
    let createBookButton = createButton(title: "Kitap Oluştur", target: self, action: #selector(createBook))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Add buttons to the view
        view.addSubview(readPredefinedBooksButton)
        view.addSubview(readMyBooksButton)
        view.addSubview(createBookButton)
        
        setupConstraints()
    }

    func setupConstraints() {
        readPredefinedBooksButton.translatesAutoresizingMaskIntoConstraints = false
        readMyBooksButton.translatesAutoresizingMaskIntoConstraints = false
        createBookButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            readPredefinedBooksButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            readPredefinedBooksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readPredefinedBooksButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readPredefinedBooksButton.heightAnchor.constraint(equalToConstant: 50),

            readMyBooksButton.topAnchor.constraint(equalTo: readPredefinedBooksButton.bottomAnchor, constant: 20),
            readMyBooksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readMyBooksButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readMyBooksButton.heightAnchor.constraint(equalToConstant: 50),

            createBookButton.topAnchor.constraint(equalTo: readMyBooksButton.bottomAnchor, constant: 20),
            createBookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createBookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createBookButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func readPredefinedBooks() {
        // Hazır kitapları oku ekranına geçiş yap
        let predefinedBooksVC = PredefinedBooksViewController()
        navigationController?.pushViewController(predefinedBooksVC, animated: true)
    }

    @objc func readMyBooks() {
        // Kullanıcının oluşturduğu kitapları oku ekranına geçiş yap
        let myBooksVC = MyBooksViewController()
        navigationController?.pushViewController(myBooksVC, animated: true)
    }

    @objc func createBook() {
        // Kitap oluştur ekranına geçiş yap
        let createBookVC = CreateBookViewController()
        navigationController?.pushViewController(createBookVC, animated: true)
    }
}
