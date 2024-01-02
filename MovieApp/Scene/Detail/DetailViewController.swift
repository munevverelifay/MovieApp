//
//  DetailViewController.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import UIKit

class DetailViewController : UIViewController, UIScrollViewDelegate {
    
//    private var genreViews = [UIView]()
//    private var genreLabels : [String] = []
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
    
    
//    private lazy var blurView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemThinMaterial)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.translatesAutoresizingMaskIntoConstraints = false
//        return blurView
//    }()
    
    private lazy var blurImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let moviePosterImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
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
    
    private lazy var imdbLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.imdblogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.typeBoldFont
        label.textAlignment = .left
        label.textColor = .movieInfoTitle
        label.text = "Genre"
        label.numberOfLines = 0
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
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
    
    
    private lazy var divider1: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .secondaryLabel
        return divider
    }()
    
    private lazy var runtimeInfo = makeAction(withImage: "clock", withTitle: "runtimeInfo")
    private lazy var releasedInfo = makeAction(withImage: "calendar", withTitle: "releasedInfo")
    private lazy var languageInfo = makeAction(withImage: "globe", withTitle: "languageInfo")
    
    private lazy var divider2: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .secondaryLabel
        return divider
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
        view.backgroundColor = .systemBackground
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewHeight()
        print("blurImageView frame: \(blurImageView.frame)")
        print("scrollView frame: \(scrollView.frame)")
        print("scrollView contentSize: \(scrollView.contentSize)")
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
        navigationController?.navigationBar.isTranslucent = true 
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
        contentView.addSubview(blurImageView)
//        contentView.addSubview(blurView)
//        blurImageView.addSubview(blurView)
        contentView.addSubview(moviePosterImageView)
      
        contentView.addSubview(genreLabel)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieRatingLabel)
        contentView.addSubview(imdbLogo)
        contentView.addSubview(divider1)
        
        contentView.addSubview(divider2)
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(runtimeInfo)
        infoStackView.addArrangedSubview(releasedInfo)
        infoStackView.addArrangedSubview(languageInfo)
        
        contentView.addSubview(movieInfoStackView)
        contentView.addSubview(movieInfoStackView)
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
    

    
    private func makeAction(withImage image: String, withTitle title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        var config = UIButton.Configuration.plain()
        config.buttonSize = .medium
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: image), for: .normal)
        button.tintColor = .label
        button.tintColor = .label
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(label)
        
        return stackView
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
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            blurImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -(WindowConstant.getTopPadding + 64)),
            blurImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            blurImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            blurImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            
//            blurView.topAnchor.constraint(equalTo: blurImageView.topAnchor),
//            blurView.leadingAnchor.constraint(equalTo: blurImageView.leadingAnchor),
//            blurView.trailingAnchor.constraint(equalTo: blurImageView.trailingAnchor),
//            blurView.bottomAnchor.constraint(equalTo: blurImageView.bottomAnchor),
            
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            moviePosterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.38),
            moviePosterImageView.heightAnchor.constraint(equalTo: moviePosterImageView.widthAnchor, multiplier: 1.67),
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieNameLabel.topAnchor.constraint(equalTo: moviePosterImageView.topAnchor, constant: 5),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            
            imdbLogo.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            imdbLogo.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            imdbLogo.heightAnchor.constraint(equalToConstant: 20),
            imdbLogo.widthAnchor.constraint(equalToConstant: 40),
            
            movieRatingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            movieRatingLabel.leadingAnchor.constraint(equalTo: imdbLogo.trailingAnchor, constant: 4),
            movieRatingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            genreLabel.topAnchor.constraint(equalTo: imdbLogo.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            genreStackView.topAnchor.constraint(equalTo: movieRatingLabel.bottomAnchor, constant: 15),
//            genreStackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
//            
            divider1.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 12),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            infoStackView.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 6),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    
            divider2.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 12),
            divider2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            divider2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            desLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 20),
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
                
                blurImageView.kf.setImage(with: url)
                moviePosterImageView.kf.setImage(with: url)
            } else {
                moviePosterImageView.image =  UIImage(named: "no_poster")
            }
            self.movieNameLabel.text = movieDetail.title
//            let ratingText = StringHelper.shared.createCustomAttributedString(iconColor: .star, labelColor: .infoText, icon: "★", font: AppFonts.infoRegularFont, text: " \(movieDetail.imdbRating)/10 IMDb")
//            self.movieRatingLabel.attributedText = ratingText
            
            self.movieRatingLabel.text = movieDetail.imdbRating
            self.genreLabel.text = movieDetail.genre
            
//            self.updateGenreLabels(movieDetail.genre)
            
//            self.runtimeInfo.text = movieDetail.runtime
//            self.releasedInfo.text = movieDetail.released
//            self.languageInfo.text = movieDetail.language
            
     
//            self.infoStringArray.append(movieDetail.runtime)
//            self.infoStringArray.append(movieDetail.released)
//            self.infoStringArray.append(movieDetail.language)
//            self.labelCreate()
//            self.imageViewCreate()
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
