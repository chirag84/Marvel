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
    private var didTapClearKey = false
    private var isFetching = false
    private var selectedIndex = IndexPath()
  
    
    lazy var searchController: UISearchController! = {
        let searchControl = UISearchController(searchResultsController: nil)
        searchControl.searchBar.placeholder = Constants.Label.searchByCharacter
        searchControl.searchBar.sizeToFit()
        searchControl.searchBar.searchTextField.textColor = .white
        searchControl.searchBar.becomeFirstResponder()
        searchControl.delegate = self
        searchControl.searchBar.delegate = self
        
        return searchControl
    }()
    
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
        
        /// Add observer to update the favorite character status
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadToUpdateFavorite),
                                               name:  NSNotification.Name("didChangeFavorite"), object: nil)
        
        // Init Network service
        self.viewModel = CharacterViewModel(service: NetworkService())
        setupView()
        setupSearchBar()
    }

    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupSearchBar() {
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func refreshCharacters() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Refresh characters record
            self.getCharacters(offset: 0)
        }
    }
    
    @objc func reloadToUpdateFavorite() {
        DispatchQueue.main.async {
            self.getCharacters(offset: self.viewModel.characterModels.count - Constants.API.limit)
            self.collectionView.reloadItems(at: [self.selectedIndex])
        }
    }
    
    func getCharacters(offset: Int, name: String? = nil) {
        self.viewModel?.fetchCharacters(offset: offset, name: name) {
            self.isFetching = false
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


//MARK: - Collection View
extension CharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.numberOfCharacters ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.charactersCell, for: indexPath) as! CharactersCell
        
        // Set character cell model
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
    
    // MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let character =  viewModel?.collectionCellModel(indexPath: indexPath).character {
         
            let viewController = CharacterDetailsViewController()
            let viewModel = CharacterDetailsViewModel(character: character)
            viewController.viewModel = viewModel
            self.selectedIndex = indexPath
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if isFetching { return }
        
        let scrollThreshold:CGFloat = 30
        let scrollDelta = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
       
        if  scrollDelta > scrollThreshold {
            isFetching = true
            self.getCharacters(offset: self.viewModel.characterModels.count)
        }
    }
}

//MARK: - Search controller delegate
extension CharacterViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !didTapClearKey && searchText.isEmpty {
            self.viewModel.searchCancelled()
            
            self.getCharacters(offset: 0)
        }
        // To avoid multiple api call while searching, reload in few seconds after last key press.
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reloadSearch(_:)), object: searchBar)
        
        // Add delay search if internet is connected
        let networkConnection = NetworkService.isConnectedToInternet()
        perform(#selector(self.reloadSearch(_:)), with: searchBar, afterDelay: networkConnection ? 0.75 : 0)
        
        didTapClearKey = false
    }
    
    @objc func reloadSearch(_ searchBar: UISearchBar) {
        self.performSearch(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        didTapClearKey = text.isEmpty
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.performSearch(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.text = ""
            self.viewModel.searchCancelled()
            
            // Reset result if search cancelled
            self.getCharacters(offset: 0)
        }
    }
    
    func performSearch(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            return
        }
        // Search characters by name
        self.viewModel.searchCharactersByName(name: searchText) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
