//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 09.09.2022.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var character: Character!
    
    //MARK: Private properties
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "Apple Color Emoji", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        title = character.name
        descriptionLabel.text = character.description
        fetchImage(from: character.image)
        setupViews()
        setConstraints()
        setLeftBarButton()
    }
    
    override func viewWillLayoutSubviews() {
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.addSubview(characterImageView)
        view.addSubview(descriptionLabel)
    }
        
    private func setLeftBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Episodes",
            style: .plain,
            target: self,
            action: #selector(getEpisode)
        )
    }
    
    @objc func getEpisode() {
        let episodesVC = EpisodesViewController()
        episodesVC.character = character
        let navigationVC = UINavigationController(rootViewController: episodesVC)
        present(navigationVC, animated: true)
    }
    
    private func fetchImage(from url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let image):
                self.characterImageView.image = UIImage(data: image)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - Set constraints
extension CharacterDetailsViewController {
    
    func setConstraints() {
        
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 240),
            characterImageView.heightAnchor.constraint(equalToConstant: 240),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }
}
