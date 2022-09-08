//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 07.09.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    static let identifier = "CharacterTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLabel)
        addSubview(characterImageView)
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: Character?) {
        nameLabel.text = character?.name
        NetworkManager.shared.fetchImage(from: character?.image) { imageData in
            self.characterImageView.image = UIImage(data: imageData)
        }
    }
}

// MARK: - Set constraints
extension CharacterTableViewCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            characterImageView.widthAnchor.constraint(equalToConstant: 50),
            characterImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
