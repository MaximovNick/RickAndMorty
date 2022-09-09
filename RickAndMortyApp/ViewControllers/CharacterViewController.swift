//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 07.09.2022.
//

import UIKit

class CharacterViewController: UIViewController {
    
    // MARK - Private Properties
    private var rickAndMorty: RickAndMorty? {
        didSet {
            filteredCharacter = rickAndMorty?.results ?? []
            tableView.reloadData()
        }
    }
    private var filteredCharacter: [Character] = []
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        title = "Character"
        
        setSubviews()
        setDelegates()
        setConstraints()
        setupNavigationBar()
        fetchData(from: Link.rickAndMortyApi.rawValue)
    }
    
    private func setSubviews() {
        view.addSubview(tableView)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        title = "Rick & Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .black
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func fetchData(from url: String?) {
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
                
            case .success(let rickAndMorty):
                self.rickAndMorty = rickAndMorty
            case .failure(let error):
                print(error)
            }
        }
    }
}


// MARK - UITableViewDelegate, UITableViewDataSource
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell()}
        
        let character = filteredCharacter[indexPath.row]
        cell.configure(with: character)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let character = filteredCharacter[indexPath.row]
        let characterDetailsVC = CharacterDetailsViewController()
        
        characterDetailsVC.character = character
        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }
}

// Set constraints
extension CharacterViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
}
