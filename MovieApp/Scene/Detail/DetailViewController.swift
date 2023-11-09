//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import UIKit

class DetailViewController : UIViewController, UIScrollViewDelegate {
    
    private var genreViews = [UIView]()
    private var genreLabels : [String] = []
    private var infoLabels = [UILabel]()
    private var iconImageViews = [UIImageView]()
    private var infoStringArray : [String] = []
    private var totalContentHeight: CGFloat = 0
    private var infoIconArray : [String] = ["clock", "calendar", "globe"]
    
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
        label.text = "Not Found"
        label.numberOfLines = 0
        return label
    }()
    
    private let movieRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoRegularFont
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Not Found"
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
        stackView.spacing = 10
        return stackView
    }()
    
    private let infoIconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
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
        label.text = "Not Found"
        label.numberOfLines = 0
        return label
    }()
    
    private let countryLabel = MovieInfoLabel(frame: .zero)
    private let actorsLabel = MovieInfoLabel(frame: .zero)
    private let ratedLabel = MovieInfoLabel(frame: .zero)
    private let writerLabel = MovieInfoLabel(frame: .zero)
    private let directorLabel = MovieInfoLabel(frame: .zero)
    private let awardsLabel = MovieInfoLabel(frame: .zero)
    private let boxOfficeLabel = MovieInfoLabel(frame: .zero)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        contentView.isHidden = true
        view.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        configureAddSubview()
        setUpConstrains()
        setUpNavigation()
        self.adjustScrollViewHeight()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.adjustScrollViewHeight()
        }, completion: nil)
    }

    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        showContent()
    }
    
    func showContent() {
        contentView.isHidden = false
    }
    
    func setUpNavigation(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func movieInfoView(country: String, actors: String, rated: String, writer: String, director: String, awards: String, boxOffice: String) {
        countryLabel.setAttributedText(title: "Country", value: country)
        actorsLabel.setAttributedText(title: "Actors", value: actors)
        ratedLabel.setAttributedText(title: "Rated", value: rated)
        writerLabel.setAttributedText(title: "Writer", value: writer)
        directorLabel.setAttributedText(title: "Director", value: director)
        awardsLabel.setAttributedText(title: "Awards", value: awards)
        boxOfficeLabel.setAttributedText(title: "Box Office", value: boxOffice)
    }
    
    func movieInfoStackAddSubview() {
        self.movieInfoStackView.addArrangedSubview(self.countryLabel)
        self.movieInfoStackView.addArrangedSubview(self.actorsLabel)
        self.movieInfoStackView.addArrangedSubview(self.ratedLabel)
        self.movieInfoStackView.addArrangedSubview(self.writerLabel)
        self.movieInfoStackView.addArrangedSubview(self.directorLabel)
        self.movieInfoStackView.addArrangedSubview(self.awardsLabel)
        self.movieInfoStackView.addArrangedSubview(self.boxOfficeLabel)
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
        contentView.addSubview(infoIconStackView)
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(dividerView)
        contentView.addSubview(desLabel)
        contentView.addSubview(desValueLabel)
    }
    
    func adjustScrollViewHeight() {
        totalContentHeight = 0
        totalContentHeight += moviePosterImageView.frame.size.height + 10
        totalContentHeight += desLabel.frame.size.height + 20
        totalContentHeight += desValueLabel.frame.size.height + 20
        totalContentHeight += actorsLabel.frame.size.height + 8
        totalContentHeight += movieInfoStackView.frame.size.height + 8
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
            label.numberOfLines = 0
        }
        for label in infoLabels {
            infoStackView.addArrangedSubview(label)
        }
    }
    
    func imageViewCreate() {
        for i in 0...2{
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .moviePrimary
            imageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
            iconImageViews.append(imageView)
            imageView.image = UIImage(systemName: infoIconArray[i])
        }
        for image in iconImageViews {
            infoIconStackView.addArrangedSubview(image)
        }
    }
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
            movieNameLabel.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor, constant: 5),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieRatingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 10),
            movieRatingLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genreStackView.topAnchor.constraint(equalTo: movieRatingLabel.bottomAnchor, constant: 15),
            genreStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            infoIconStackView.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 14),
            infoIconStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            infoStackView.topAnchor.constraint(equalTo: genreStackView.bottomAnchor, constant: 15),
            infoStackView.leadingAnchor.constraint(equalTo: infoIconStackView.trailingAnchor, constant: 4),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dividerView.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 10),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            desLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            desLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            desLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            desValueLabel.topAnchor.constraint(equalTo: desLabel.bottomAnchor, constant: 10),
            desValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            desValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            movieInfoStackView.topAnchor.constraint(equalTo: desValueLabel.bottomAnchor, constant: 20),
            movieInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}

extension DetailViewController: MovieDetailViewModelOutput {
    func showError(error: CustomError?) {
        if let error {
            self.showErrorAlert(for: error)
        }
    }
    
    func updateView(movieDetail: MovieDetailData?) {
        guard let movieDetail = movieDetail else {
            print("Movie Detail nil gelmiş olur buraya error yazılabilir")
            return
        }
        
        DispatchQueue.main.async { [self] in
            self.title = movieDetail.title
            if let url = URL(string: movieDetail.poster) {
                moviePosterImageView.kf.setImage(with: url)
            } else {
                moviePosterImageView.image =  UIImage(named: "no_poster")
            }
            self.movieNameLabel.text = movieDetail.title
            let ratingText = StringHelper.shared.createCustomAttributedString(iconColor: .star, labelColor: .infoText, icon: "★", font: AppFonts.infoRegularFont, text: " \(movieDetail.imdbRating)/10 IMDb")
            self.movieRatingLabel.attributedText = ratingText
            self.updateGenreLabels(movieDetail.genre)
            self.infoStringArray.append(movieDetail.runtime)
            self.infoStringArray.append(movieDetail.released)
            self.infoStringArray.append(movieDetail.language)
            self.labelCreate()
            self.imageViewCreate()
            self.desValueLabel.text = movieDetail.plot
            
            movieInfoView(country: movieDetail.country, actors: movieDetail.actors, rated: movieDetail.rated, writer: movieDetail.writer, director: movieDetail.director, awards: movieDetail.awards, boxOffice: movieDetail.boxOffice)
            
            self.movieInfoStackAddSubview()
            self.stopLoading()
            self.showContent()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                      self.adjustScrollViewHeight()
            }
        }
    }
}
