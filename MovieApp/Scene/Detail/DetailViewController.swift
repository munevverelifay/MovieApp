//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import UIKit //ekranın ortasına koy loadingi her şeyi gizle sonra aç

class DetailViewController : UIViewController, UIScrollViewDelegate {
    
    private var genreViews = [UIView]()
    private var genreLabels : [String] = []
    private var infoLabels = [UILabel]()
    private var infoStringArray : [String] = []
    private var totalContentHeight: CGFloat = 0
    
    private let viewModel: MovieDetailViewModel
    var movieDetail : MovieDetailData?
    
    init(viewModel: MovieDetailViewModel, imdbID: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        
        self.viewModel.fetchMovieDetail(id: imdbID)
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let navigationView : UIView = {
        let navigationView = UIView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.backgroundColor = .white
        return navigationView
    }()

    private let moviePosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.movieTitleBoldFont
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoRegularFont
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let genreStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    let dividerView: UIView = {
        let dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor.systemGray3
        return dividerView
    }()
    
    private let desLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoTitleBlackFont
        label.textAlignment = .left
        label.textColor = .movieInfoTitle
        label.text = "Description"
        label.numberOfLines = 0
        return label
    }()
    private let desValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.desRegularFont
        label.textAlignment = .left
        label.textColor = .infoText
        label.numberOfLines = 0
        return label
    }()
    private let actorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoTitleBlackFont
        label.textAlignment = .left
        label.textColor = .movieInfoTitle
        label.text = "Cast"
        label.numberOfLines = 0
        return label
    }()
    private let actorValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.desRegularFont
        label.textAlignment = .left
        label.textColor = .infoText
        label.numberOfLines = 0
        return label
    }()
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoTitleBlackFont
        label.textAlignment = .left
        label.textColor = .movieInfoTitle
        label.text = "Director"
        label.numberOfLines = 0
        return label
    }()
    private let directorValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.desRegularFont
        label.textAlignment = .left
        label.textColor =  .infoText
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        view.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        configureAddSubview()
        setUpConstrains()
        setUpNavigation()
        self.adjustScrollViewHeight()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func configureAddSubview() {
        view.addSubview(navigationView)
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        scrollView.addSubview(contentView)
        scrollView.addSubview(contentView)
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(genreStackView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(dividerView)
        contentView.addSubview(desLabel)
        contentView.addSubview(desValueLabel)
        contentView.addSubview(actorLabel)
        contentView.addSubview(actorValueLabel)
        contentView.addSubview(directorLabel)
        contentView.addSubview(directorValueLabel)
    }
    
    func adjustScrollViewHeight() {
        totalContentHeight += moviePosterImageView.frame.size.height + 10
        totalContentHeight += movieNameLabel.frame.size.height + 10
        totalContentHeight += movieRatingLabel.frame.size.height + 15
        totalContentHeight += genreStackView.frame.size.height + 15
        totalContentHeight += infoStackView.frame.size.height + 20
        totalContentHeight += desLabel.frame.size.height + 8
        totalContentHeight += desValueLabel.frame.size.height + 15
        totalContentHeight += actorLabel.frame.size.height + 8
        totalContentHeight += actorValueLabel.frame.size.height + 15
        totalContentHeight += directorLabel.frame.size.height + 8
        totalContentHeight += directorValueLabel.frame.size.height + 15

        scrollView.contentSize = CGSize(width: contentView.frame.size.width, height: totalContentHeight)
    }

    func updateGenreLabels(_ genre: String) {
        genreLabels = []
        let genres = genre.components(separatedBy: ", ")
        
        for genreLabel in genres {
            genreLabels.append(genreLabel)
        }
        viewCreate()
    }
    
    func viewCreate() {
        for _ in 0...genreLabels.count - 1 {
            let genreView = GenreView()
            genreView.translatesAutoresizingMaskIntoConstraints = false
            genreView.clipsToBounds = true
            genreView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            genreView.layer.cornerRadius = 15
            genreViews.append(genreView)
        }
        for genreLabel in genreLabels {
            let genreView = GenreView()
            genreView.configure(with: genreLabel)
            genreStackView.addArrangedSubview(genreView)
        }
    }
    func labelCreate() {
        for i in 0...2{
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.clipsToBounds = true
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.font = AppFonts.infoSemiBoldFont
            infoLabels.append(label)
            label.text = " \(infoStringArray[i])"
        }
        for label in infoLabels {
            infoStackView.addArrangedSubview(label)
        }
    }
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(WindowConstant.getTopPadding + 64)),
            navigationView.heightAnchor.constraint(equalToConstant: WindowConstant.getTopPadding + 64),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            moviePosterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor, multiplier: 1.67),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            movieRatingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 10),
            movieRatingLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genreStackView.topAnchor.constraint(equalTo: movieRatingLabel.bottomAnchor, constant: 15),
            genreStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            
            infoStackView.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 15),
            infoStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 10),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dividerView.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 10),
//            dividerView.widthAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
   
            desLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            desLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            desValueLabel.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 8),
            desValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            desValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            actorLabel.topAnchor.constraint(equalTo: desValueLabel.bottomAnchor, constant: 15),
            actorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            actorValueLabel.topAnchor.constraint(equalTo: actorLabel.bottomAnchor, constant: 8),
            actorValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actorValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            directorLabel.topAnchor.constraint(equalTo: actorValueLabel.bottomAnchor, constant: 15),
            directorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            directorValueLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 8),
            directorValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            directorValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}

extension DetailViewController: MovieDetailViewModelOutput {
    func updateView(movieDetail: MovieDetailData?) {
        guard let movieDetail = movieDetail else {
            print("Movie Detail nil gelmiş olur buraya error yazılabilir")
            return
        }

        DispatchQueue.main.async {
            self.title = movieDetail.title
            if let url = URL(string: movieDetail.poster) {
                self.moviePosterImageView.kf.setImage(with: url)
            }
            self.movieNameLabel.text = movieDetail.title
            let ratingText = StringHelper.shared.createCustomAttributedString(iconColor: .star, labelColor: .infoText, icon: "★", font: AppFonts.infoRegularFont, text: " \(movieDetail.imdbRating)/10 IMDb")
            self.movieRatingLabel.attributedText = ratingText
            self.updateGenreLabels(movieDetail.genre)
            self.infoStringArray.append(movieDetail.runtime)
            self.infoStringArray.append(movieDetail.released)
            self.infoStringArray.append(movieDetail.language)
            self.labelCreate()
            self.desValueLabel.text = movieDetail.plot
            self.actorValueLabel.text = movieDetail.actors
            self.directorValueLabel.text = movieDetail.director
            self.adjustScrollViewHeight()
            self.stopLoading()
        }
    }
}
