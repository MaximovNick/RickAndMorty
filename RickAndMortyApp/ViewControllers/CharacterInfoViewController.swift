//
//  CharacterInfoViewController.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 13.09.2022.
//

import UIKit

class CharacterInfoViewController: UIViewController {
    
    //MARK: Public properties
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
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(
            red: 21/255,
            green: 32/255,
            blue: 66/255,
            alpha: 1
        )
        
        title = character.name
        descriptionLabel.text = character.description
        
        setupViews()
        setConstraints()
        fetchImage(from: character.image)
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(
                title: "",
                style: .plain,
                target: nil,
                action: nil
            )
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = characterImageView.frame.width / 2
    }
    
    // MARK: - Private methods
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
extension CharacterInfoViewController {
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
