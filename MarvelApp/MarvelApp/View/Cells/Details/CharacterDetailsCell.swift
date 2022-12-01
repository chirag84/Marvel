//
//  CharacterDetailCell.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation
import UIKit
import Kingfisher

class CharacterDetailsCell: UICollectionViewCell {
    
    var viewModel: CharacterDetailsCellModelProtocol?
    
    let containerView: UIView! = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black

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
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = .white
       
        return label
    }()

    lazy var descriptionLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
   
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    func setupView(){
        backgroundColor = UIColor.clear
        
        addSubview(containerView)
        //containerView.addSubview(stackView)
        
        containerView.addSubview(characterImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        
        // keep a proportion
        let imageWidth = (UIScreen.main.bounds.width - 50.0) / 2.0
        let imageHeight = imageWidth * 1.86
        
        characterImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1).isActive = true
        characterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 1).isActive = true
        characterImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -1).isActive = true
        characterImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 21).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5).isActive = true
    }
    
    func configure(cellModel: CharacterDetailsCellModelProtocol) {
        self.viewModel = cellModel
        
        // Set character title
        titleLabel.text = self.viewModel?.titleText
        
        // Set thumb character image
        if let path = self.viewModel?.imagePath {
            characterImageView.kf.setImage(with: URL(string: path))
        }
        
        descriptionLabel.text = self.viewModel?.descriptionText
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
