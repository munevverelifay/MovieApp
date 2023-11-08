//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import UIKit

class MoviesViewController: UIViewController {
    
    private let viewModel: MoviesViewModel
    private var movies : MoviesData?
    private var originalMoviesArray: [Search?] = []
    private var moviesArray : [Search?] = [] {
        didSet {
            sortMovies = originalMoviesArray
            reverseMovies = sortMovies.reversed()
            sortYearsMovies = sortMovies.sorted(by: { first, second in
                if let firstYear = first?.year, let secondYear = second?.year {
                    return firstYear < secondYear
                } else {
                    return false
                }
            })
            reverseYearsMovies = sortYearsMovies.reversed()
        }
    }
    
    private var currentSortEnum: SortTypes = .sort
    private var sortMovies: [Search?] = []
    private var reverseMovies: [Search?] = []
    private var sortYearsMovies: [Search?] = []
    private var reverseYearsMovies: [Search?] = []
    
    var page : Int = 1
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearched = false
    private var isFetchingMovies = false
    private var searchText = ""
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let navigationView : UIView = {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = .white
        return navigationView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let width = UIScreen.main.bounds.width
        let itemWidth = (width - 44)
        layout.itemSize = CGSize(width: itemWidth, height: 140)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.viewModel.fetchMovies(page: "1")
        view.addSubview(moviesCollectionView)
        view.addSubview(navigationView)
        view.addSubview(sortButton)
        view.addSubview(errorLabel)
        setupSearchController()
        setUpConstrains()
        setUpNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    
    func setUpNavigation(){
        title = "MovieApp"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        //
    }
    
    func setUpConstrains() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        moviesCollectionView.isScrollEnabled = true
        moviesCollectionView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(WindowConstant.getTopPadding + 91)),
            navigationView.heightAnchor.constraint(equalToConstant: WindowConstant.getTopPadding + 91),
            moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            //burada font vs verebilirsin
        }
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
        definesPresentationContext = true
    }
    
    @objc func sortButtonTapped() {
        switch currentSortEnum {
        case .sort:
            currentSortEnum = .reverseSort
            sortButton.setTitle("Reverse Sort", for: .normal)
        case .reverseSort:
            currentSortEnum = .sortYear
            sortButton.setTitle("Oldest Sort", for: .normal)
        case .sortYear:
            moviesArray = sortYearsMovies
            currentSortEnum = .reverseSortYear
            sortButton.setTitle("Newest Sort", for: .normal)
        case .reverseSortYear:
            currentSortEnum = .sort
            sortButton.setTitle("Sort", for: .normal)
        }
        switch currentSortEnum {
        case .sort:
            moviesArray = sortMovies
        case .reverseSort:
            moviesArray = reverseMovies
        case .sortYear:
            moviesArray = sortYearsMovies
        case .reverseSortYear:
            moviesArray = reverseYearsMovies
        }
        
        moviesCollectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        moviesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
}


extension MoviesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == moviesArray.count - 3 {
            self.page += 1
            if isSearched {
                self.viewModel.fetchSerchedMovies(page: String(describing: page), movie: searchController.searchBar.text)
            } else {
                self.viewModel.fetchMovies(page: String(describing: page))
            }
        }
        
        if let movie = moviesArray[indexPath.item] {
            cell.cellData = movie
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovieIndex = indexPath.item
        if let selectedMovie = moviesArray[selectedMovieIndex] {
            if let selectedMovieIMDbID = selectedMovie.imdbID {
                
                let moviesService : MoviesService = APIManager()
                let movieDetailViewModel = MovieDetailViewModel(moviesService: moviesService) //emincan
                let detailViewController = DetailViewController(viewModel: movieDetailViewModel, imdbID: selectedMovieIMDbID)
                navigationController?.pushViewController(detailViewController, animated: true)
            }
        }
    }
}

extension MoviesViewController : MovieViewModelOutput {
    func showError(error: CustomError?) {
        if let error {
            self.showErrorAlert(for: error)
        }
    }
    
    func updateView(movies: MoviesData?) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
            self.movies = movies
            if movies?.search?.count != 0 {
                if let search = movies?.search {
                    self.originalMoviesArray.append(contentsOf: search)
                    self.moviesArray.append(contentsOf: search)
                }
            } else {
                self.originalMoviesArray = []
                self.moviesArray = []
                self.page = 1
            }
            self.moviesCollectionView.reloadData()
            self.isFetchingMovies = false
        }
    }
    
    func updateErrorView(error: String?) {
        DispatchQueue.main.async {
            if let error {
                self.errorLabel.isHidden = false
                self.originalMoviesArray = []
                self.moviesArray = []
                self.moviesCollectionView.reloadData()
                self.errorLabel.text = error
                self.page = 1
            }
            self.isFetchingMovies = false
        }
    }
}

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let count = searchController.searchBar.text?.count {
            if searchController.searchBar.text != "", count > 2{
                if !isFetchingMovies {
                    isFetchingMovies = true
                    self.moviesArray = []
                    self.originalMoviesArray = []
                    self.page = 1
                    self.isSearched = true
                    self.viewModel.fetchSerchedMovies(page: String(describing: page), movie: searchController.searchBar.text)
                }
            }else if searchController.searchBar.text == ""{
                if (movies?.error == nil) {
                    if searchText != ""{
                        if isSearched {
                            self.isSearched = true
                            searchController.searchBar.text = searchText
                        } else {
                            self.isSearched = true
                            self.moviesArray = []
                            self.originalMoviesArray = []
                            self.page = 1
                        }
                    } else {
                        self.isSearched = false
                        self.moviesArray = []
                        self.originalMoviesArray = []
                        self.page = 1
                        if !isFetchingMovies {
                            isFetchingMovies = true
                            self.viewModel.fetchMovies(page: String(describing: page))
                        }
                    }
                    if moviesArray.isEmpty, originalMoviesArray.isEmpty {
                        
                    } else {
                        let indexPath = IndexPath(item: 0, section: 0)
                        moviesCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
}

extension MoviesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearched = false
            self.searchText = ""
        } else {
            isSearched = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchController.searchBar.text ?? ""
        if searchText == "" {
            isSearched = false
        } else {
            isSearched = true
        }
    }
}

