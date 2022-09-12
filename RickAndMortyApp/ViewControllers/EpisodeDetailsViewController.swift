//
//  EpisodeDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 12.09.2022.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    var episode: Episode!
    
    private var characters: [Character] = [] {
        didSet {
            if characters.count == episode.characters.count {
                characters = characters.sorted { $0.id < $1.id}
            }
        }
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "fasfafafa"
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.text = "Characters"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )

        title = episode.episode
        descriptionLabel.text = episode.description
        
        tableView.rowHeight = 70
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        
        setConstraints()
    }
    
    private func setupViews() {
        view.addSubview(descriptionLabel)
        view.addSubview(characterLabel)
        view.addSubview(tableView)
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EpisodeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episode.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        let characterURL = episode.characters[indexPath.row]
        NetworkManager.shared.fetchCharacter(from: characterURL) { character in
            switch character {
            case .success(let character):
                cell.configure(with: character)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
}

// MARK: - SetConstraints
extension EpisodeDetailsViewController {
    
    private func setConstraints() {
    
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            characterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: characterLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}
