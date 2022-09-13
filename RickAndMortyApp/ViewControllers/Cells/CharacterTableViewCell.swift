//
//  CharacterTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Nikolai Maksimov on 07.09.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    static let identifier = "CharacterTableViewCell"
    
    //MARK: Private properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(characterImageView)
        addSubview(nameLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with character: Character?) {
        nameLabel.text = character?.name
        NetworkManager.shared.fetchImage(from: character?.image) { [weak self] imageData in
            guard let self = self else { return }
            self.characterImageView.layer.cornerRadius = self.characterImageView.frame.height / 2
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
