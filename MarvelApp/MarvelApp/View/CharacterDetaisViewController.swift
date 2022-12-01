//
//  CharacterDetaisViewController.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var viewModel: CharacterDetailsViewModel?
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    lazy var flowLayout: UICollectionViewFlowLayout! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = sectionInsets
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView! = {
        var view = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        view.register(CharacterDetailsCell.self, forCellWithReuseIdentifier: Constants.Cell.characterDeatilsCell)
        view.register(CharactersCell.self, forCellWithReuseIdentifier: Constants.Cell.charactersCell)
        view.register(ComicsCell.self, forCellWithReuseIdentifier: Constants.Cell.comicsCell)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCollectionViewLayout(flowLayout, animated: true)
       // view.refreshControl?.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = UIColor.clear
        view.alwaysBounceVertical = false
       // view.addSubview(refreshControl)
        view.isScrollEnabled = true
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.title = Constants.Label.characterDetails
      
        setupView()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.collectionView.layoutIfNeeded()
    }
        
}

//MARK: - Collection View
extension CharacterDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel?.numberOfComics ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.characterDeatilsCell, for: indexPath) as! CharacterDetailsCell
            
            guard let cellModel = viewModel?.collectionCellModel(indexPath: indexPath) else {
                return CharacterDetailsCell()
            }
            
            cell.configure(cellModel: cellModel)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.comicsCell, for: indexPath) as! ComicsCell
            guard let cellModel = viewModel?.comicCellModel(indexPath: indexPath) else {
                return ComicsCell()
            }
            cell.configure(cellModel: cellModel)
            return cell
        }
       
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Padding between cell
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let width = ((collectionView.frame.width - paddingSpace) / itemsPerRow)
     
        let size = (UIScreen.main.bounds.size.width - 40) / 2
        if indexPath.section == 0 {
            // Character details cell size
            return CGSize(width: UIScreen.main.bounds.size.width, height: size * 2.4)
        }
          
        // Comics cell size
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if(section == 0){
            return 0
        }
        
        return 8.0
    }
   
}
