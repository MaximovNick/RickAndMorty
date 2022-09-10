//
//  CharacterViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 07.09.2022.
//

import UIKit

class CharacterViewController: UIViewController {
    
    // MARK - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var rickAndMorty: RickAndMorty? {
        didSet {
            filteredCharacter = rickAndMorty?.results ?? []
            tableView.reloadData()
        }
    }
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var filteredCharacter: [Character] = []
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
  
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Prev",
            style: .plain,
            target: self,
            action: #selector(updateData))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(updateData))
        
        setSubviews()
        setDelegates()
        setConstraints()
        setupNavigationBar()
        setupSearchController()
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    @objc func updateData(_ sender: UIBarButtonItem) {
        sender.title == "Next" ? fetchData(from: rickAndMorty?.info.next) : fetchData(from: rickAndMorty?.info.prev)
    }
}


// MARK - UITableViewDelegate, UITableViewDataSource
extension CharacterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredCharacter.count : rickAndMorty?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell()}
        
        let character = isFiltering ? filteredCharacter[indexPath.row] : rickAndMorty?.results[indexPath.row]
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

extension CharacterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCharacter = rickAndMorty?.results.filter { character in
            character.name.lowercased().contains(searchText.lowercased())
        } ?? []
        
        tableView.reloadData()
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
