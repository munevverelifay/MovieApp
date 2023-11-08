//
//  FilterView.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 8.11.2023.
//

import UIKit

class FilterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .orange
        setupUI()
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choouse Select Filter"
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let movieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let serieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let serieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let serieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let episodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let episodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let gameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
       
    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Filter", for: .normal)
        return button
    }()
    
    private func setupUI() {
        addSubview(headerLabel)
        addSubview(mainStackView)
        addSubview(filterButton)
        movieStackView.addArrangedSubview(movieButton)
        movieStackView.addArrangedSubview(movieLabel)
        mainStackView.addArrangedSubview(movieStackView)
        serieStackView.addArrangedSubview(serieButton)
        serieStackView.addArrangedSubview(serieLabel)
        mainStackView.addArrangedSubview(serieStackView)
        episodeStackView.addArrangedSubview(episodeButton)
        episodeStackView.addArrangedSubview(episodeLabel)
        mainStackView.addArrangedSubview(episodeStackView)
        gameStackView.addArrangedSubview(gameButton)
        gameStackView.addArrangedSubview(gameLabel)
        mainStackView.addArrangedSubview(gameStackView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor,constant: 10),
            filterButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    
}
