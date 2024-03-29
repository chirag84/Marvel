//
//  CharactersCell.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import UIKit
import Kingfisher

class CharactersCell: UICollectionViewCell {
    
    var viewModel: CharactersCellModelProtocol?
    
    let containerView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 6.0
        
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.alignment = .center
        view.axis  = .vertical
        view.spacing = 3
        
        return view
    }()
    
    lazy var characterImageView: UIImageView! = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 2.0
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
       
        return label
    }()

    lazy var favoriteButton: UIButton! = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.backgroundColor = .clear
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .red
        button.isHidden = true
        
        return button
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView(){
        backgroundColor = UIColor.clear
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(favoriteButton)
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        favoriteButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 42).isActive = true

        stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
        
        titleLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        stackView.addArrangedSubview(characterImageView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    func configure(cellModel: CharactersCellModelProtocol) {
        self.viewModel = cellModel
        
        // Set character title
        titleLabel.text = self.viewModel?.titleText
        
        // Set character image
        if let path = self.viewModel?.imagePath {
            characterImageView.kf.setImage(with: URL(string: path))
        }
        
        favoriteButton.isSelected = self.viewModel?.isFavorite ?? false
        favoriteButton.isHidden = favoriteButton.isSelected ? false : true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
