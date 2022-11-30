//
//  ViewController.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import UIKit

class CharacterViewController: UIViewController {

    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    private var cellId = "CharactersCell"
  
  
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        return refreshControl
    }()
    
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
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCollectionViewLayout(flowLayout, animated: true)
        view.backgroundColor = UIColor.clear
        view.addSubview(refreshControl)
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = true
        view.refreshControl?.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        view.isScrollEnabled = true
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func setupView() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func refreshCharacters() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
        }
        
    }
    
    func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
}


//MARK: - CollectionView
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let width = ((collectionView.frame.width - paddingSpace) / itemsPerRow)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
}
