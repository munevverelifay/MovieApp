//
//  MovieCell.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    static let cellIdentifier = String(describing: MovieCell.self)
    
    var cellData: Search? {
        didSet {
            guard let search = cellData else { return }
            movieNameLabel.text = search.title
            movieYearLabel.text = search.year
            
            if search.type == .movie {
                movieTypeLabel.text = "Movie" //bunu switche çevir ve genreviewa doldur
            } else if search.type == .series {
                movieTypeLabel.text = "Series"
            }
            if let url = URL(string: search.poster ?? "") {
                moviePosterImageView.kf.setImage(with: url)
            }
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
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
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let movieTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.typeBoldFont
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let movieYearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.infoRegularFont
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setUpConstrains()
    }
    
    func configure() {
        addSubview(moviePosterImageView)
        addSubview(movieNameLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieTypeLabel)
        stackView.addArrangedSubview(movieYearLabel)
    }
    
    func setUpConstrains() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor),
            moviePosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            moviePosterImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -5),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
