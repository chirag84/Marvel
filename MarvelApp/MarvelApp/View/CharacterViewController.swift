//
//  ViewController.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import UIKit

class CharacterViewController: UIViewController {

    var viewModel: CharacterViewModel!
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
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
        view.register(CharactersCell.self, forCellWithReuseIdentifier: Constants.Cell.charactersCell)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setCollectionViewLayout(flowLayout, animated: true)
        view.refreshControl?.addTarget(self, action: #selector(refreshCharacters), for: .valueChanged)
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = UIColor.clear
        view.alwaysBounceVertical = false
        view.addSubview(refreshControl)
        view.isScrollEnabled = true
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = Constants.Label.marvelCharacters
        self.viewModel = CharacterViewModel(service: NetworkService())
        setupView()
        
        // Fetch characters
        self.getCharacters(offset: 0)
    }

    private func setupView() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func refreshCharacters() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getCharacters(offset: 0)
        }
        
    }
    
    func getCharacters(offset: Int, name: String? = nil) {
        self.viewModel?.fetchCharacters(offset: offset, name: name) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                
                if(self.refreshControl.isRefreshing) {
                    self.stopRefresher()
                }
            }
        }
    }
    
    
    func stopRefresher() {
        self.refreshControl.endRefreshing()
    }
}


//MARK: - CollectionView
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.numberOfCharacters ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.charactersCell, for: indexPath) as! CharactersCell
        
        guard let cellModel = viewModel?.collectionCellModel(indexPath: indexPath) else {
            return CharactersCell()
        }
        
        cell.configure(cellModel: cellModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Padding between cell
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
