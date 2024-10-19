//
//  StorySectionCell.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 16.10.2024.
//

import UIKit

class StorySectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var items: [String] = []
    var showAllButtonAction: ((_ indexPath: IndexPath) -> Void)? // IndexPath parametresi ekliyoruz
    var itemSelectedAction: ((_ item: String) -> Void)? // Seçilen kitabı geri döndürmek için
    var indexPath: IndexPath? // Hücrenin indexPath'ini tutmak için

    private let titleLabel = UILabel()
    private let showAllButton = UIButton(type: .system)
    private let collectionView: UICollectionView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // Collection view layout setup for horizontal scrolling
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup views
    private func setupViews() {
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        showAllButton.setTitle("Tümünü Göster", for: .normal)
        showAllButton.addTarget(self, action: #selector(showAllTapped), for: .touchUpInside)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BlockCell")

        contentView.addSubview(titleLabel)
        contentView.addSubview(showAllButton)
        contentView.addSubview(collectionView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        showAllButton.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            showAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            showAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // Configure cell with section title and items
    func configure(with title: String, items: [String], at indexPath: IndexPath) {
        self.items = items
        titleLabel.text = title
        self.indexPath = indexPath // Hücrede indexPath'i sakla
        collectionView.reloadData()
    }

    @objc func showAllTapped() {
        guard let indexPath = indexPath else { return }
        showAllButtonAction?(indexPath) // IndexPath'i geri gönderiyoruz
    }

    // MARK: - Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlockCell", for: indexPath)
        
        // Hücrenin içindeki eski alt görselleri (subviews) temizle
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }

        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 8
        
        // Yeni UILabel ekleme
        let label = UILabel()
        label.text = items[indexPath.item]
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16) // Burada font boyutunu düzenledik

        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }

    // Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item] // Seçilen kitabı al
        itemSelectedAction?(selectedItem) // Seçilen kitabı geri döndür
    }
    
}
