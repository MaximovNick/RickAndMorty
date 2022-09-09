//
//  CharacterDetailsViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 09.09.2022.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var character: Character!
    
    private var spinnerView = UIActivityIndicatorView()
    
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
        showSpinner(in: view)
        descriptionLabel.text = character.description
        
        setupViews()
        setConstraints()
      
        fetchImage(from: character.image)
    }
    
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
            descriptionLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}
