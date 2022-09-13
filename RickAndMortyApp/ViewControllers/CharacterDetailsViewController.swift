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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var spinnerView = UIActivityIndicatorView()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = character.name
        
        descriptionLabel.text = character.description
        
        
        setupViews()
        setConstraints()
        
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Episodes",
            style: .plain,
            target: self,
            action: #selector(getEpisode)
        )
    }
    
    override func viewWillLayoutSubviews() {
        
        showSpinner(in: view)
        fetchImage(from: character.image)
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
    }
    
    @objc func getEpisode() {
        let episodesVC = EpisodesViewController()
        episodesVC.character = character
        let navigationVC = UINavigationController(rootViewController: episodesVC)
        present(navigationVC, animated: true)
    }
    
    // MARK: - Private methods
    private func fetchImage(from url: String?) {
        
        NetworkManager.shared.fetchImage(from: url) { imageData in
            self.characterImageView.image = UIImage(data: imageData)
            self.spinnerView.stopAnimating()
        }
    }
    
    private func setupViews() {
        view.addSubview(characterImageView)
        view.addSubview(descriptionLabel)
    }
}

// MARK: - ActivityIndicator
extension CharacterDetailsViewController {
    
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .white
        spinnerView.startAnimating()
        spinnerView.center = characterImageView.center
        spinnerView.hidesWhenStopped = true
        
        view.addSubview(spinnerView)
    }
}

// Set constraints
extension CharacterDetailsViewController {
    
    func setConstraints() {
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
