//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 09.09.2022.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var character: Character!
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = character.name
        view.backgroundColor = .white
        
        descriptionLabel.text = character.description
        
        setupViews()
        setConstraints()
        
        fetchImage(from: character.image)
        
    }
    
    private func fetchImage(from url: String?) {
        
        NetworkManager.shared.fetchImage(from: url) { imageData in
            self.characterImageView.image = UIImage(data: imageData)
        }
    }
    
    private func setupViews() {
        
        view.addSubview(characterImageView)
        view.addSubview(descriptionLabel)
    }
}

// Set constraints
extension CharacterDetailsViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
        
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}
